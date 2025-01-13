import React from "react";
import { ResultItem } from "./ResultItem";

export const ResultsSection = ({ results, loading, error }) => {
  if (loading) {
    return (
      <div className="results-loading">
        <p>Searching...</p>
      </div>
    );
  }

  if (error) {
    return <div className="results-error">{error}</div>;
  }

  if (!results || results.length === 0) {
    return (
      <div className="results-empty">
        <p>There are zero matches.</p>
        <p>Use the form to search for People or Movies.</p>
      </div>
    );
  }

  return (
    <div className="results-section">
      {results.map((result, index) => (
        <ResultItem key={index} result={result} />
      ))}
    </div>
  );
};
