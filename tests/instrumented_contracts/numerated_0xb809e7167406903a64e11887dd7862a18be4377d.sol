1 pragma solidity ^0.4.21;
2 
3 contract Token{
4     function transfer(address _to, uint256 _value){_to;_value;}
5 }
6 
7 contract BatchTransfer{
8     address public owner;
9     mapping (address => bool) public admins;
10     Token public token;
11     
12     modifier onlyOwner{
13         require(msg.sender == owner);
14         _;
15     }
16     
17     modifier onlyOwnerOrAdmin{
18         require(msg.sender == owner || admins[msg.sender] == true);
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
31     function ownerSetAdmin(address[] _admins) public onlyOwner{
32         for(uint i = 0; i<_admins.length; i++){
33             admins[_admins[i]] = true;
34         }
35     }
36     
37     function ownerModAdmin(address _admin, bool _authority) onlyOwner{
38         admins[_admin] = _authority;
39     }
40     
41     function ownerTransfer(address _addr, uint _value) public onlyOwner{
42         token.transfer(_addr,_value);
43     }
44     
45     function executeBatchTransfer(address[] _dests, uint[] _values) public onlyOwnerOrAdmin returns(uint){
46         uint i = 0;
47         while (i < _dests.length) {
48             token.transfer(_dests[i], _values[i] * (10 ** 18));
49             i += 1;
50         }
51         return i;
52     }
53     
54     
55 }