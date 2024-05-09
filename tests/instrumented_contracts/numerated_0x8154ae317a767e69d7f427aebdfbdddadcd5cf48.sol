1 contract Rating {
2         function setRating(bytes32 _key, uint256 _value) {
3             ratings[_key] = _value;
4         }
5         mapping (bytes32 => uint256) public ratings;
6     }