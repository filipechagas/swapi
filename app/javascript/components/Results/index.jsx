import React from "react";
import { ResultsSection } from "./ResultsSection";
import "./styles.css";

export const Results = ({ results, loading, error }) => (
  <div className="bg-white p-6 rounded-lg shadow">
    <h2 className="text-lg mb-4">Results</h2>
    <ResultsSection results={results} loading={loading} error={error} />
  </div>
);
