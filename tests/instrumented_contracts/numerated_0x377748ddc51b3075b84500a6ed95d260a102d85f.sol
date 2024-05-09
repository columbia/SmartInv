1 pragma solidity ^0.4.19;
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
3 contract TuneToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     mapping (address => uint256) public balanceOf;
9     mapping (address => mapping (address => uint256)) public allowance;
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     function TuneToken() public {
12         totalSupply = 3e9 * 10 ** uint256(decimals);
13         balanceOf[msg.sender] = totalSupply;                
14         name = "TUNE Token";                            
15         symbol = "TUNE";                
16     }
17     function _transfer(address _from, address _to, uint _value) internal {
18         require(_to != 0x0);
19         require(balanceOf[_from] >= _value);
20         require(balanceOf[_to] + _value > balanceOf[_to]);
21         uint previousBalances = balanceOf[_from] + balanceOf[_to];
22         balanceOf[_from] -= _value;
23         balanceOf[_to] += _value;
24         Transfer(_from, _to, _value);
25         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
26     }
27     /**
28      * @param _to The address of the recipient
29      * @param _value the amount to send
30      */
31     function transfer(address _to, uint256 _value) public {
32         _transfer(msg.sender, _to, _value);
33     }
34     
35     /**
36      * @param _from The address of the sender
37      * @param _to The address of the recipient
38      * @param _value the amount to send
39      */
40     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
41         require(_value <= allowance[_from][msg.sender]);
42         allowance[_from][msg.sender] -= _value;
43         _transfer(_from, _to, _value);
44         return true;
45     }
46     
47     /**
48      * @param _spender The address authorized to spend
49      * @param _value the max amount they can spend
50      */
51     function approve(address _spender, uint256 _value) public
52         returns (bool success) {
53         allowance[msg.sender][_spender] = _value;
54         return true;
55     }
56     
57     /**
58      * @param _spender The address authorized to spend
59      * @param _value the max amount they can spend
60      * @param _extraData some extra information to send to the approved contract
61      */
62     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
63         public
64         returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, this, _extraData);
68             return true;
69         }
70     }
71 }