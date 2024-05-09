1 pragma solidity ^0.4.16;
2 
3 contract LCEToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8 
9     mapping (address => uint256) public balanceOf;
10     mapping (address => mapping (address => uint256)) public allowance;
11 
12     event Transfer(address indexed from, address indexed to, uint256 
13 
14 value);
15     event Burn(address indexed from, uint256 value);
16 
17     function LCEToken() public {
18         totalSupply = 1500000000 * 10 ** uint256(decimals);
19         balanceOf[msg.sender] = totalSupply;
20         name = "Linecycle";
21         symbol = "LCE";
22     }
23 
24     function _transfer(address _from, address _to, uint _value) internal 
25 
26 {
27         require(_to != 0x0);
28         require(balanceOf[_from] >= _value);
29         require(balanceOf[_to] + _value > balanceOf[_to]);
30         uint previousBalances = balanceOf[_from] + balanceOf[_to];
31         balanceOf[_from] -= _value;
32         balanceOf[_to] += _value;
33      emit   Transfer(_from, _to, _value);
34         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
35     }
36 
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40 
41     function transferFrom(address _from, address _to, uint256 _value) 
42 
43 public returns (bool success) {
44         require(_value <= allowance[_from][msg.sender]);     
45         allowance[_from][msg.sender] -= _value;
46         _transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) public returns 
51 
52 (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56 
57     function burn(uint256 _value) public returns (bool success) {
58         require(balanceOf[msg.sender] >= _value);   
59         balanceOf[msg.sender] -= _value;            
60         totalSupply -= _value;                      
61       emit  Burn(msg.sender, _value);
62         return true;
63     }
64 
65     function burnFrom(address _from, uint256 _value) public returns 
66 
67 (bool success) {
68         require(balanceOf[_from] >= _value);                
69         require(_value <= allowance[_from][msg.sender]);    
70         balanceOf[_from] -= _value;                         
71         allowance[_from][msg.sender] -= _value;             
72         totalSupply -= _value;                              
73        emit Burn(_from, _value);
74         return true;
75     }
76 }