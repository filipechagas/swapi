import React from "react";

export const SearchInput = ({
  value,
  onChange,
  onSearch,
  disabled,
  searchType,
}) => {
  const getPlaceholder = () => {
    return searchType === "people"
      ? "e.g. Chewbacca, Yoda, Boba Fett"
      : "e.g. A New Hope, Empire Strikes Back";
  };

  return (
    <div>
      <input
        type="text"
        placeholder={getPlaceholder()}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="search-input"
      />
      <button
        onClick={onSearch}
        disabled={disabled}
        className="action-button search-button"
      >
        {disabled ? <div className="loader">SEARCHNG...</div> : "SEARCH"}
      </button>
    </div>
  );
};
