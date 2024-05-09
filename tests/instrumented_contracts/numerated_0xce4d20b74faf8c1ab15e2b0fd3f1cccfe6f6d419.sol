1 pragma solidity ^0.4.18;
2 
3 contract JpToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 2;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13 
14 
15     function JpToken() public {
16         totalSupply = 50000000* 10 ** uint256(decimals);  // Update total supply with the decimal amount
17         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
18         name = "JPToken";                                   // Set the name for display purposes
19         symbol = "JPT";                               // Set the symbol for display purposes
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
33      function transfer(address _to, uint256 _value) public {
34         _transfer(msg.sender, _to, _value);
35     }
36 
37     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
38         require(_value <= allowance[_from][msg.sender]);     // Check allowance
39         allowance[_from][msg.sender] -= _value;
40         _transfer(_from, _to, _value);
41         return true;
42     }
43 
44    
45     function approve(address _spender, uint256 _value) public returns (bool success) {
46         allowance[msg.sender][_spender] = _value;
47         return true;
48     }
49 
50     
51 }