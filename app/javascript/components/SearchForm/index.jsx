import React from "react";
import { SearchType } from "./SearchType";
import { SearchInput } from "./SearchInput";

export const SearchForm = ({
  searchType,
  onSearchTypeChange,
  searchQuery,
  onSearchQueryChange,
  onSearch,
  loading,
}) => (
  <div className="bg-white p-6 rounded-lg shadow">
    <h2 className="text-lg mb-4">What are you searching for?</h2>
    <SearchType selected={searchType} onChange={onSearchTypeChange} />
    <SearchInput
      value={searchQuery}
      onChange={onSearchQueryChange}
      onSearch={onSearch}
      disabled={loading}
      searchType={searchType}
    />
  </div>
);
