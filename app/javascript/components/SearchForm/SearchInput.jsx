import React from "react";
import { Search as SearchIcon, Loader } from "lucide-react";

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
    <div className="relative">
      <input
        type="text"
        placeholder={getPlaceholder()}
        value={value}
        onChange={(e) => onChange(e.target.value)}
        className="w-full px-4 py-2 border rounded-lg mb-2"
      />
      <button
        onClick={onSearch}
        disabled={disabled}
        className={`w-full py-2 rounded-lg ${
          disabled ? "bg-gray-300" : "bg-green-500 hover:bg-green-600"
        } text-white flex items-center justify-center`}
      >
        {disabled ? (
          <Loader className="w-5 h-5 animate-spin" />
        ) : (
          <>
            <SearchIcon className="w-5 h-5 mr-2" />
            SEARCH
          </>
        )}
      </button>
    </div>
  );
};
