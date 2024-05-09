1 pragma solidity ^0.4.16;
2  /**
3      * B2AND Token contract
4      *
5      * The final version 2018-02-18
6  */
7 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
8 contract Ownable {
9     address public owner;
10     function Ownable() public {
11         owner = msg.sender;
12     }
13     modifier onlyOwner() {
14         require(msg.sender == owner);
15         _;
16     }
17     function transferOwnership(address newOwner) public onlyOwner {
18         require(newOwner != address(0));
19         owner = newOwner;
20     }
21 }
22 contract B2ANDcoin is Ownable {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;   
26     uint256 public totalSupply;
27     mapping (address => uint256) public balanceOf;
28     mapping (address => mapping (address => uint256)) public allowance;
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Burn(address indexed from, uint256 value);
31     function B2ANDcoin(
32     ) public {
33         totalSupply = 100000000 * 10 ** uint256(decimals);  
34         balanceOf[msg.sender] = totalSupply;               
35         name = "B2ANDcoin";                                
36         symbol = "B2C";                  
37     }
38     function _transfer(address _from, address _to, uint _value) internal {
39         require(_to != 0x0);
40         require(balanceOf[_from] >= _value);
41         require(balanceOf[_to] + _value > balanceOf[_to]);
42         uint previousBalances = balanceOf[_from] + balanceOf[_to];
43         balanceOf[_from] -= _value;
44         balanceOf[_to] += _value;
45         Transfer(_from, _to, _value);
46         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
47     }
48     function transfer(address _to, uint256 _value) public {
49         _transfer(msg.sender, _to, _value);
50     }
51     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
52         require(_value <= allowance[_from][msg.sender]);    
53         allowance[_from][msg.sender] -= _value;
54         _transfer(_from, _to, _value);
55         return true;
56     }
57     function approve(address _spender, uint256 _value) public
58         returns (bool success) {
59         allowance[msg.sender][_spender] = _value;
60         return true;
61     }
62     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
63         public
64         returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, this, _extraData);
68             return true;
69         }
70     }
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);   
73         balanceOf[msg.sender] -= _value;           
74         totalSupply -= _value;                     
75         Burn(msg.sender, _value);
76         return true;
77     }
78     function burnFrom(address _from, uint256 _value) public returns (bool success) {
79         require(balanceOf[_from] >= _value);               
80         require(_value <= allowance[_from][msg.sender]);   
81         balanceOf[_from] -= _value;                         
82         allowance[_from][msg.sender] -= _value;            
83         totalSupply -= _value;                            
84         Burn(_from, _value);
85         return true;
86     }
87 }