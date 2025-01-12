import React from "react";
import { Loader } from "lucide-react";
import { ResultItem } from "./ResultItem";

export const ResultsSection = ({ results, loading, error }) => {
  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <Loader className="w-8 h-8 animate-spin text-blue-500" />
      </div>
    );
  }

  if (error) {
    return <div className="text-center text-red-500 p-4">{error}</div>;
  }

  if (!results || results.length === 0) {
    return (
      <div className="text-center text-gray-500 p-4">
        <p>There are zero matches.</p>
        <p>Use the form to search for People or Movies.</p>
      </div>
    );
  }

  return (
    <div className="space-y-4">
      {results.map((result, index) => (
        <ResultItem key={index} result={result} />
      ))}
    </div>
  );
};
