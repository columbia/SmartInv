1 pragma solidity >=0.4.22 <0.6.0;
2 contract EventThrower {
3     event SomethingHappened (
4        string nonIndexedString,
5        string indexed indexedString,
6        uint nonIndexedInt,
7        uint indexed indexedInt,
8        bool nonIndexedBool,
9        address nonIndexedAddress,
10        address indexed indexedAddress
11     );
12     
13      function throwEvent(string memory _nonIndexedString, string memory _indexedString, uint _nonIndexedInt, uint _indexedInt, bool _nonIndexedBool, address _nonIndexedAddress, address _indexedAddress) public {
14        emit SomethingHappened(_nonIndexedString, _indexedString, _nonIndexedInt, _indexedInt, _nonIndexedBool, _nonIndexedAddress, _indexedAddress);
15     }
16 }