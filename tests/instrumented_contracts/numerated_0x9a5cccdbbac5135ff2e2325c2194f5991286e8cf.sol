1 pragma solidity ^0.4.18;
2 
3 contract MyIMMN {
4     address private owner;
5 
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9 
10     uint256 public totalSupply;
11 
12     mapping (address => uint256) public balanceOf;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     constructor(
17         uint256 initialSupply,
18         string tokenName,
19         string tokenSymbol
20     ) public {
21         owner = 0xe3FC95aC1F99871A891830AeE0bFadFB4E3C6859;
22 
23         totalSupply = initialSupply * 10 ** uint256(decimals);
24         balanceOf[msg.sender] = totalSupply;
25         name = tokenName;
26         symbol = tokenSymbol;
27     }
28 
29     function transferOwnership(address newOwner) public {
30 		require(msg.sender == owner);
31         owner = newOwner;
32     }
33 
34     function _transfer(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value >= balanceOf[_to]);
38 
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         emit Transfer(_from, _to, _value);
42     }
43 
44     function transfer(address _to, uint256 _value) public {
45         _transfer(msg.sender, _to, _value);
46     }
47 }