1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TidePodsToken {
6     string public name;
7     string public symbol;
8     uint8 public decimals = 18;
9     uint256 public totalSupply;
10 
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     function TidePodsToken() public {
17         totalSupply = 2e6 * 10 ** uint256(decimals);
18         balanceOf[msg.sender] = totalSupply;                
19         name = "TIDE PODS";                            
20         symbol = "PODS";                
21     }
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
33     /**
34      * @param _to The address of the recipient
35      * @param _value the amount to send
36      */
37     function transfer(address _to, uint256 _value) public {
38         _transfer(msg.sender, _to, _value);
39     }
40     
41     /**
42      * @param _from The address of the sender
43      * @param _to The address of the recipient
44      * @param _value the amount to send
45      */
46     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
47         require(_value <= allowance[_from][msg.sender]);
48         allowance[_from][msg.sender] -= _value;
49         _transfer(_from, _to, _value);
50         return true;
51     }
52     
53     /**
54      * @param _spender The address authorized to spend
55      * @param _value the max amount they can spend
56      */
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value;
60         return true;
61     }
62     
63     /**
64      * @param _spender The address authorized to spend
65      * @param _value the max amount they can spend
66      * @param _extraData some extra information to send to the approved contract
67      */
68     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
69         public
70         returns (bool success) {
71         tokenRecipient spender = tokenRecipient(_spender);
72         if (approve(_spender, _value)) {
73             spender.receiveApproval(msg.sender, _value, this, _extraData);
74             return true;
75         }
76     }
77 }