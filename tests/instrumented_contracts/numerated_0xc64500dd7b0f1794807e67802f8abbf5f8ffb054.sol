1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint _value, address _token, bytes _extraData) external; }
4 
5 contract LocusToken {
6     
7     address public tokenOwner;
8     
9     string public constant name = "Locus Chain";
10     string public constant symbol = "LOCUS";
11     
12     uint8 public constant decimals = 18;
13     uint public totalSupply;
14     
15     uint internal constant initialSupply = 7000000000 * (10 ** uint(decimals));
16     
17     mapping(address => uint) public balanceOf;
18     mapping(address => mapping(address => uint)) internal allowed;
19 	
20 	function balanceOfToken(address _owner) public view returns(uint) {
21 	    return balanceOf[_owner];
22 	}
23     
24     function allowance(address _owner, address _spender) public view returns(uint) {
25         return allowed[_owner][_spender];
26     }
27     
28     event Transfer(address indexed from, address indexed to, uint value);
29     event Approval(address indexed owner, address indexed spender, uint value);
30     event Burn(address indexed from, uint value);
31     
32     function LocusToken() public {
33         tokenOwner = msg.sender;
34         totalSupply = initialSupply;
35         balanceOf[tokenOwner] = totalSupply;
36     }
37     
38     function _transfer(address _from, address _to, uint _value) internal {
39         require(_to != address(0));
40         require(_value <= balanceOf[_from]);
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         uint prevBalances = balanceOf[_from] + balanceOf[_to];
43         balanceOf[_from] -= _value;
44         balanceOf[_to] += _value;
45         emit Transfer(_from, _to, _value);
46         assert(balanceOf[_from] + balanceOf[_to] == prevBalances);
47     }
48     
49     function transfer(address _to, uint _value) public returns(bool) {
50         _transfer(msg.sender, _to, _value);
51         return true;
52     }
53     
54     function transferFrom(address _from, address _to, uint _value) public returns(bool) {
55         require(_value <= allowed[_from][msg.sender]);
56         allowed[_from][msg.sender] -= _value;
57         _transfer(_from, _to, _value);
58         return true;
59     }
60     
61     function approve(address _spender, uint _value) public returns(bool) {
62         allowed[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66 
67     function approveAndCall(address _spender, uint _value, bytes _extraData) public returns(bool) {
68         tokenRecipient spender = tokenRecipient(_spender);
69         if(approve(_spender, _value)) {
70             spender.receiveApproval(msg.sender, _value, this, _extraData);
71             return true;
72         }
73     }
74     
75     function burn(uint _value) public returns(bool) {
76         require(_value <= balanceOf[msg.sender]);
77         balanceOf[msg.sender] -= _value;
78         totalSupply -= _value;
79         emit Burn(msg.sender, _value);
80         emit Transfer(msg.sender, address(0), _value);
81         return true;
82     }  
83 }