import React from "react";

export const SearchInput = ({
  value,
  onChange,
  onSearch,
  disabled,
  loading,
  searchType,
  popularSearches,
  isLoadingPopular,
}) => {
  const getPlaceholder = () => {
    if (isLoadingPopular) {
      return "Loading popular searches...";
    }

    return searchType === "people"
      ? `e.g. ${popularSearches.people}`
      : `e.g. ${popularSearches.movies}`;
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
        {loading ? <div className="loader">SEARCHING...</div> : "SEARCH"}
      </button>
    </div>
  );
};
