1 pragma solidity ^0.4.24;
2 
3 
4 
5 contract PT {
6 
7     string public name ;
8     string public symbol ;
9     uint8 public decimals = 18;  
10     uint256 public totalSupply  ;  
11 
12     mapping (address => uint256) public balanceOf;
13     
14    
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     
19 
20     function PT(uint256 initialSupply, string tokenName, string tokenSymbol) public {
21         totalSupply = initialSupply * 10 ** uint256(decimals);
22 
23         balanceOf[msg.sender] = totalSupply;    
24 
25         name = tokenName;
26         symbol = tokenSymbol;
27     }
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30 
31         require(_to != 0x0);
32 
33         require(balanceOf[_from] >= _value);
34 
35         require(balanceOf[_to] + _value > balanceOf[_to]);
36 
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38 
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41 
42         emit Transfer(_from, _to, _value);
43 
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46 
47     function transfer(address _to, uint256 _value) public {
48         _transfer(msg.sender, _to, _value);
49     }
50 	
51 	
52 }