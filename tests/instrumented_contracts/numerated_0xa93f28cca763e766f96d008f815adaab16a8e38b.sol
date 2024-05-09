1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract Levblockchain {
6     string public name="Levblockchain";
7     string public symbol="LVE";
8     uint8 public decimals = 18;
9     uint256 public totalSupply=108000000;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     
15     event Transfer(address indexed from, address indexed to, uint256 value);
16      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
17      event Burn(address indexed from, uint256 value);
18      
19     constructor (
20         uint256 initialSupply ,
21         string tokenName,
22         string tokenSymbol
23        
24         
25         
26     ) public {
27         totalSupply = initialSupply=108000000 * 10 ** uint256(decimals); 
28         balanceOf[msg.sender
29 ] = totalSupply;        
30         name = tokenName="Levblockchain";            
31         symbol = tokenSymbol="LVE";               
32     }
33           
34     function _transfer(address _from, address _to, uint _value) internal {
35         require(_to != 0x0);
36         require(balanceOf[_from] >= _value);
37         require(balanceOf[_to] + _value >= balanceOf[_to]);
38         uint previousBalances = balanceOf[_from] + balanceOf[_to];
39         balanceOf[_from] -= _value;
40         balanceOf[_to] += _value;
41         emit Transfer(_from, _to, _value);
42         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
43     }
44     function transfer(address _to, uint256 _value) public returns (bool success) {
45         _transfer(msg.sender, _to, _value);
46         return true;
47     }
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= allowance[_from][msg.sender]);    
50         allowance[_from][msg.sender] -= _value;
51         _transfer(_from, _to, _value);
52         return true;
53     }
54     function approve(address _spender, uint256 _value) public
55         returns (bool success) {
56         allowance[msg.sender][_spender] = _value;
57         emit Approval(msg.sender, _spender, _value);
58         return true;
59         }
60         function approveAndCall(address _spender, uint256 _value, bytes _extraData)
61         public
62         returns (bool success) {
63         tokenRecipient spender = tokenRecipient(_spender);
64         if (approve(_spender, _value)) {
65             spender.receiveApproval(msg.sender, _value, this, _extraData);
66             return true;
67         }
68     }
69     function burn(uint256 _value) public returns (bool success) {
70         require(balanceOf[msg.sender] >= _value);   
71         balanceOf[msg.sender] -= _value;            
72         totalSupply -= _value;                      
73         emit Burn(msg.sender, _value);
74         return true;
75     }
76     function burnFrom(address _from, uint256 _value) public returns (bool success) {
77         require(balanceOf[_from] >= _value);             
78         require(_value <= allowance[_from][msg.sender]);  
79         balanceOf[_from] -= _value;                         
80         allowance[_from][msg.sender] -= _value;
81         totalSupply -= _value;                              
82         emit Burn(_from, _value);
83         return true;
84     }
85     
86 }