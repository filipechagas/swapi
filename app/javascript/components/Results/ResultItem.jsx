import React from "react";

export const ResultItem = ({ result }) => (
  <div className="result-item">
    <div className="result-info">
      <h3>{result.name || result.title}</h3>
    </div>
    <button className="action-button">SEE DETAILS</button>
  </div>
);
