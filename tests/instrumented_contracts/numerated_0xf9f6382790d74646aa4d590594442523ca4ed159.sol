1 pragma solidity ^0.4.21;
2 
3 contract Token{
4     function transfer(address _to, uint256 _value){_to;_value;}
5 }
6 
7 contract BatchTransfer{
8     address public owner;
9     address public admin;
10     Token public token;
11     
12     modifier onlyOwner{
13         require(msg.sender == owner);
14         _;
15     }
16     
17     modifier onlyOwnerOrAdmin{
18         require(msg.sender == owner || msg.sender == admin);
19         _;
20     }
21     
22     function BatchTransfer(address _tokenAddr) public {
23         owner = msg.sender;
24         token = Token(_tokenAddr);
25     }
26     
27     function ownerSetOwner(address newOwner) public onlyOwner{
28         owner = newOwner;
29     }
30     
31     function ownerSetAdmin(address newAdmin) public onlyOwner{
32         admin = newAdmin;
33     }
34     
35     function ownerTransfer(address _addr, uint _value) public onlyOwner{
36         token.transfer(_addr,_value);
37     }
38     
39     function executeBatchTransfer(address[] _dests, uint[] _values) public onlyOwnerOrAdmin returns(uint){
40         uint i = 0;
41         while (i < _dests.length) {
42             token.transfer(_dests[i], _values[i] * (10 ** 18));
43             i += 1;
44         }
45         return i;
46     }
47     
48     
49 }