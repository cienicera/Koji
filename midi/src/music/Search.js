import React, { useState } from "react";
import "./search.css";

const Search = () => {
  const [inputValue, setInputValue] = useState("");

  const handleChange = (event) => {
    setInputValue(event.target.value);
  };

  return (
    <div>
          <form>
                  
            
        <label className="label">Input midi file address</label>
        <input
          className="inputfield"
          type="text"
          value={inputValue}
          onChange={handleChange}
                  /> 
                  
        <button className="button" type="submit">
          Load Music
        </button>
      </form>
    </div>
  );
};

export default Search;
