import { useState, useEffect, useCallback } from "react";

export const useStarWarsSearch = () => {
  const [searchType, setSearchType] = useState("people");
  const [searchQuery, setSearchQuery] = useState("");
  const [results, setResults] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [popularSearches, setPopularSearches] = useState({
    people: "",
    movies: "",
  });
  const [popularSearchesLoading, setPopularSearchesLoading] = useState(true);
  const [popularSearchesError, setPopularSearchesError] = useState(null);

  const fetchPopularSearches = useCallback(async () => {
    try {
      setPopularSearchesLoading(true);
      setPopularSearchesError(null);
      const response = await fetch(
        "/api/v1/statistics/popular_searches_by_type",
      );
      const data = await response.json();
      setPopularSearches({
        people: data.people,
        movies: data.movies,
      });
    } catch (error) {
      console.error("Error fetching popular searches:", error);
      setPopularSearchesError(error);
    } finally {
      setPopularSearchesLoading(false);
    }
  }, []);

  useEffect(() => {
    fetchPopularSearches();
  }, [searchType, fetchPopularSearches]);

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

  return {
    searchType,
    setSearchType,
    searchQuery,
    setSearchQuery,
    results,
    loading,
    error,
    handleSearch,
    popularSearches,
    popularSearchesLoading,
    popularSearchesError,
    refreshPopularSearches: fetchPopularSearches,
  };
};
