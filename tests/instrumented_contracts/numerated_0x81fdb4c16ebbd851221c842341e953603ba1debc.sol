1 pragma solidity ^0.4.16;
2 
3 contract InitialCoinOfferingToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 3;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Burn(address indexed from, uint256 value);
14 
15     function InitialCoinOfferingToken() public {
16         totalSupply = 2600000000 * 10 ** uint256(decimals);
17         balanceOf[msg.sender] = totalSupply;
18         name = "Initial Coin Offering Token";
19         symbol = "ICOT";
20     }
21 
22     function _transfer(address _from, address _to, uint _value) internal {
23         require(_to != 0x0);
24         require(balanceOf[_from] >= _value);
25         require(balanceOf[_to] + _value > balanceOf[_to]);
26         uint previousBalances = balanceOf[_from] + balanceOf[_to];
27         balanceOf[_from] -= _value;
28         balanceOf[_to] += _value;
29         Transfer(_from, _to, _value);
30         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
31     }
32     
33     function multisend(address _tokenAddr, address[] dests, uint256[] values) 
34         returns (uint256) {
35         uint256 i = 0;
36         while (i < dests.length) {
37             InitialCoinOfferingToken(_tokenAddr).transfer(dests[i], values[i]);
38             i += 1;
39         }
40         return(i);
41     }
42 
43     function transfer(address _to, uint256 _value) public {
44         _transfer(msg.sender, _to, _value);
45     }
46 
47     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
48         require(_value <= allowance[_from][msg.sender]);     
49         allowance[_from][msg.sender] -= _value;
50         _transfer(_from, _to, _value);
51         return true;
52     }
53 
54     function approve(address _spender, uint256 _value) public returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58 
59     function burn(uint256 _value) public returns (bool success) {
60         require(balanceOf[msg.sender] >= _value);   
61         balanceOf[msg.sender] -= _value;            
62         totalSupply -= _value;                      
63         Burn(msg.sender, _value);
64         return true;
65     }
66 
67     function burnFrom(address _from, uint256 _value) public returns (bool success) {
68         require(balanceOf[_from] >= _value);                
69         require(_value <= allowance[_from][msg.sender]);    
70         balanceOf[_from] -= _value;                         
71         allowance[_from][msg.sender] -= _value;             
72         totalSupply -= _value;                              
73         Burn(_from, _value);
74         return true;
75     }
76 }