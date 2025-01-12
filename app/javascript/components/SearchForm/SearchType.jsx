import React from "react";

export const SearchType = ({ selected, onChange }) => (
  <div className="search-type-container">
    <label className="search-type-label">
      <input
        type="radio"
        name="searchType"
        value="people"
        checked={selected === "people"}
        onChange={(e) => onChange(e.target.value)}
        className="search-type-radio"
      />
      <span>People</span>
    </label>
    <label className="search-type-label">
      <input
        type="radio"
        name="searchType"
        value="films"
        checked={selected === "films"}
        onChange={(e) => onChange(e.target.value)}
        className="search-type-radio"
      />
      <span>Movies</span>
    </label>
  </div>
);
