1 pragma solidity ^ 0.4.16;
2 
3 interface tokenRecipient {
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
5 }
6 
7 contract TokenERC20 {
8     string public name="RMG";
9     string public symbol="RMG";
10     uint8 public decimals = 18; 
11     uint256 public totalSupply;
12 
13     mapping(address => uint256) public balanceOf;
14     mapping(address => mapping(address => uint256)) public allowance;
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     constructor() public {
19         totalSupply = 330000000 * 10 ** uint256(decimals);
20         balanceOf[msg.sender] = totalSupply;
21         
22     }
23 
24     function _transfer(address _from, address _to, uint _value) internal {
25         require(_to != 0x0);
26         require(balanceOf[_from] >= _value);
27         require(balanceOf[_to] + _value > balanceOf[_to]);
28 
29         uint previousBalances = balanceOf[_from] + balanceOf[_to];
30         // Subtract from the sender
31         balanceOf[_from] -= _value;
32         // Add the same to the recipient
33         balanceOf[_to] += _value;
34         emit Transfer(_from, _to, _value);
35 
36         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
37     }
38 
39     function transfer(address _to, uint256 _value) public {
40         _transfer(msg.sender, _to, _value);
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
44         require(_value <= allowance[_from][msg.sender]); // Check allowance
45         allowance[_from][msg.sender] -= _value;
46         _transfer(_from, _to, _value);
47         return true;
48     }
49 
50     function approve(address _spender, uint256 _value) public
51     returns(bool success) {
52         allowance[msg.sender][_spender] = _value;
53         return true;
54     }
55 
56     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
57     public
58     returns(bool success) {
59         tokenRecipient spender = tokenRecipient(_spender);
60         if (approve(_spender, _value)) {
61             spender.receiveApproval(msg.sender, _value, this, _extraData);
62             return true;
63         }
64     }
65 
66 }