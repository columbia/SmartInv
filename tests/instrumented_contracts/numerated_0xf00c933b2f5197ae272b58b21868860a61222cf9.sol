1 pragma solidity ^0.4.17;
2 contract ApoIPFS
3  {
4       mapping (address => mapping (string => string)) apos;
5 
6 
7       function setIPFS(address _addr,string datetime,string _ipfshash) public
8       {
9           
10           if(bytes(apos[_addr][datetime]).length==0)
11           {
12               apos[_addr][datetime] = _ipfshash;
13           }
14       }
15       
16 
17       function getIPFS(address _addr,string datetime) public constant returns (string)
18       {
19            
20             return apos[_addr][datetime];
21       }
22 
23 }