import React, { useState } from "react";

import { SearchForm } from "../SearchForm";
import { Results } from "../Results";
import { useStarWarsSearch } from "./useStarWarsSearch";

import "./style.css";

const App = () => {
  const {
    searchType,
    setSearchType,
    searchQuery,
    setSearchQuery,
    results,
    loading,
    error,
    handleSearch,
  } = useStarWarsSearch();

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
