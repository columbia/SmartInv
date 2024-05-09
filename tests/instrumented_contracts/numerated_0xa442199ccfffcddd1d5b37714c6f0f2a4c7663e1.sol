1 pragma solidity ^0.4.16;
2 
3 /* suport  tocoin.com 
4  * ┌┬┐┌─┐┌─┐┌─┐ ┬ ┌─┐    ┌┬┐┌─┐┌─┐┌┬┐   
5  *  │ │ ││  │ │ │ │ │     │ ├┤ ├─┤│││ 
6  *  ┴ └─┘└─┘└─┘ ┴ ┴ ┴     ┴ └─┘┴ ┴┴ ┴ 
7  */
8 
9 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
10 
11 contract TokenERC20 {
12     string public name;
13     string public symbol;
14     uint8 public decimals = 18;
15     uint256 public totalSupply;
16 
17     mapping (address => uint256) public balanceOf;
18     mapping (address => mapping (address => uint256)) public allowance;
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
23 
24     event Burn(address indexed from, uint256 value);
25 
26     function TokenERC20(
27         uint256 initialSupply,
28         string tokenName,
29         string tokenSymbol
30     ) public {
31         totalSupply = initialSupply * 10 ** uint256(decimals);  
32         balanceOf[msg.sender] = totalSupply;              
33         name = tokenName;                                  
34         symbol = tokenSymbol;   
35     }
36 
37     function _transfer(address _from, address _to, uint _value) internal {
38         require(_to != 0x0);
39         require(balanceOf[_from] >= _value);
40         require(balanceOf[_to] + _value >= balanceOf[_to]);
41         uint previousBalances = balanceOf[_from] + balanceOf[_to];
42         balanceOf[_from] -= _value;
43         balanceOf[_to] += _value;
44         emit Transfer(_from, _to, _value);
45         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
46     }
47 
48     function transfer(address _to, uint256 _value) public returns (bool success) {
49         _transfer(msg.sender, _to, _value);
50         return true;
51     }
52 
53    
54     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
55         require(_value <= allowance[_from][msg.sender]);
56         allowance[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60 
61  
62     function approve(address _spender, uint256 _value) public
63         returns (bool success) {
64         allowance[msg.sender][_spender] = _value;
65         emit Approval(msg.sender, _spender, _value);
66         return true;
67     }
68 
69   
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         public
72         returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79 
80     
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);   
83         balanceOf[msg.sender] -= _value;           
84         totalSupply -= _value;                   
85         emit Burn(msg.sender, _value);
86         return true;
87     }
88 
89     
90     function burnFrom(address _from, uint256 _value) public returns (bool success) {
91         require(balanceOf[_from] >= _value);                
92         require(_value <= allowance[_from][msg.sender]);   
93         balanceOf[_from] -= _value;                      
94         allowance[_from][msg.sender] -= _value;          
95         totalSupply -= _value;                           
96         emit Burn(_from, _value);
97         return true;
98     }
99 }