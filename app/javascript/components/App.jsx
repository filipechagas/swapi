import React, { useState } from "react";
import { SearchForm } from "./SearchForm";
import { Results } from "./Results";
import "./App.css";

const App = () => {
  const [searchType, setSearchType] = useState("people");
  const [searchQuery, setSearchQuery] = useState("");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const handleSearch = async () => {
    if (!searchQuery.trim()) return;
    setLoading(true);
    setError(null);

    try {
      const response = await fetch("/api/v1/searches", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          search: {
            query: searchQuery,
            type: searchType,
          },
        }),
      });
      const data = await response.json();
      if (data.error) {
        setError(data.error);
        setResults([]);
      } else {
        setResults(data.results || []);
      }
    } catch (err) {
      setError("An error occurred while searching. Please try again.");
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="app">
      <div className="app-header">
        <h1>SWStarter</h1>
      </div>
      <div className="app-content">
        <SearchForm
          searchType={searchType}
          onSearchTypeChange={setSearchType}
          searchQuery={searchQuery}
          onSearchQueryChange={setSearchQuery}
          onSearch={handleSearch}
          loading={loading}
        />
        <Results results={results} loading={loading} error={error} />
      </div>
    </div>
  );
};

export default App;
