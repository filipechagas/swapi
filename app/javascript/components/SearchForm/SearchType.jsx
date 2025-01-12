import React from "react";

export const SearchType = ({ selected, onChange }) => (
  <div className="flex gap-6 mb-4">
    <label className="flex items-center cursor-pointer">
      <input
        type="radio"
        name="searchType"
        value="people"
        checked={selected === "people"}
        onChange={(e) => onChange(e.target.value)}
        className="w-4 h-4 text-blue-500 cursor-pointer"
      />
      <span className="ml-2">People</span>
    </label>
    <label className="flex items-center cursor-pointer">
      <input
        type="radio"
        name="searchType"
        value="films"
        checked={selected === "films"}
        onChange={(e) => onChange(e.target.value)}
        className="w-4 h-4 text-blue-500 cursor-pointer"
      />
      <span className="ml-2">Movies</span>
    </label>
  </div>
);
