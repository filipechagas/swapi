import React from "react";
import { SearchType } from "./SearchType";
import { SearchInput } from "./SearchInput";
import "./styles.css";

export const SearchForm = ({
  searchType,
  onSearchTypeChange,
  searchQuery,
  onSearchQueryChange,
  onSearch,
  loading,
  popularSearches,
  isLoadingPopular,
}) => {
  return (
    <div className="search-form-container">
      <h2 className="search-form-heading">What are you searching for?</h2>
      <SearchType selected={searchType} onChange={onSearchTypeChange} />
      <SearchInput
        value={searchQuery}
        onChange={onSearchQueryChange}
        onSearch={onSearch}
        disabled={loading}
        searchType={searchType}
        popularSearches={popularSearches}
        isLoadingPopular={isLoadingPopular}
      />
    </div>
  );
};
