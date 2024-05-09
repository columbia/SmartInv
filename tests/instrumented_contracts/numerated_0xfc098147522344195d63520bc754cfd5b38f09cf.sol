1 pragma solidity ^0.4.26;
2 
3 contract SurfExUtilityToken {
4 
5     string public name;
6     string public symbol;
7     uint8 public decimals = 8;
8     uint256 public totalSupply;
9 
10     mapping (address => uint256) public balanceOf;
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed from, uint256 value);
14     
15     constructor(
16     
17           uint256 initialSupply,
18         string tokenName,
19         string tokenSymbol
20         ) public{
21               totalSupply = initialSupply*10**uint256(decimals);
22             balanceOf[msg.sender] = totalSupply;
23             name = tokenName;
24             symbol = tokenSymbol;
25     }
26     
27     function _transfer(address _from, address _to, uint _value) internal {
28         
29         require(_to !=0x0);
30         require(balanceOf[_from] >=_value);
31         require(balanceOf[_to] + _value >= balanceOf[_to]);
32         
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         
35         balanceOf[_from] -= _value;
36         balanceOf[_to] += _value;
37         
38         emit Transfer (_from, _to, _value);
39         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
40         
41     }
42     
43     
44     function transfer(address _to, uint256 _value) public returns (bool success){
45         
46         _transfer(msg.sender, _to, _value);
47         return true;
48     }
49     
50     function burn (uint256 _value) public returns (bool success){
51         require(balanceOf[msg.sender] >= _value);
52         
53         balanceOf[msg.sender] -= _value;
54         totalSupply -= _value;
55         emit Burn(msg.sender, _value);
56         return true;
57     }
58     
59     
60 }