1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract TokenERC20 {
8     string public name;
9     string public symbol;
10     uint8 public decimals = 10;
11     uint256 public totalSupply;
12 
13     mapping (address => uint256) public balanceOf;
14 
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17 
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     event Burn(address indexed from, uint256 value);
21 
22     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
23         totalSupply = initialSupply * 10 ** uint256(decimals);  
24         balanceOf[msg.sender] = totalSupply;  
25         name = tokenName;                     
26         symbol = tokenSymbol;                
27     }
28 
29     function _transfer(address _from, address _to, uint _value) internal {
30         require(_to != 0x0);
31         require(balanceOf[_from] >= _value);
32         require(balanceOf[_to] + _value > balanceOf[_to]);
33         uint previousBalances = balanceOf[_from] + balanceOf[_to];
34         balanceOf[_from] -= _value;
35         balanceOf[_to] += _value;
36         Transfer(_from, _to, _value);
37 
38         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
39     }
40 
41     function transfer(address _to, uint256 _value) public  returns (bool) {
42         _transfer(msg.sender, _to, _value);
43        return true;
44     }
45 
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);
48         allowance[_from][msg.sender] -= _value;
49         _transfer(_from, _to, _value);
50         return true;
51     }
52 
53     function approve(address _spender, uint256 _value) public
54         returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         return true;
57     }
58     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
59         public
60         returns (bool success) {
61         tokenRecipient spender = tokenRecipient(_spender);
62         if (approve(_spender, _value)) {
63             spender.receiveApproval(msg.sender, _value, this, _extraData);
64             return true;
65         }
66     }
67     function batchSend(address[] _receivers, uint256 _value) public  returns (bool) {
68         uint cnt = _receivers.length;
69         uint256 amount = uint256(cnt) * _value;
70         require(cnt > 0 && cnt <= 20);
71         require(_value > 0 && balanceOf[msg.sender] >= amount);
72     
73         balanceOf[msg.sender] = balanceOf[msg.sender] -= amount;
74         for (uint i = 0; i < cnt; i++) {
75             balanceOf[_receivers[i]] = balanceOf[_receivers[i]]+=_value;
76             Transfer(msg.sender, _receivers[i], _value);
77         }
78         return true;
79         
80     }
81 }