import React from "react";
import { ResultsSection } from "./ResultsSection";
import "./styles.css";

export const Results = ({ results, loading, error }) => (
  <div className="results-container">
    <h2 className="results-heading">Results</h2>
    <ResultsSection results={results} loading={loading} error={error} />
  </div>
);
