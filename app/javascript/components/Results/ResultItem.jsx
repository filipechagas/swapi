import React from "react";

export const ResultItem = ({ result }) => (
  <div className="p-4 border rounded-lg hover:bg-gray-50">
    <h3 className="font-bold">{result.name || result.title}</h3>
    {result.birth_year && <p>Birth Year: {result.birth_year}</p>}
    {result.release_date && <p>Release Date: {result.release_date}</p>}
  </div>
);
