1 pragma solidity ^0.4.24;
2 
3 contract GaiBanngToken {
4 
5     string public name = '丐帮令牌';      //  token name
6     string constant public symbol = "GAI";           //  token symbol
7     uint256 constant public decimals = 8;            //  token digit
8 
9     uint256 public constant INITIAL_SUPPLY = 20170808 * (10 ** uint256(decimals));
10     
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14     uint256 public totalSupply = 0;
15     address public owner = 0x0;
16 
17     modifier isOwner {
18         assert(owner == msg.sender);
19         _;
20     }
21     function transferOwnership(address newOwner) public isOwner {
22         require(newOwner != address(0));
23         emit OwnershipTransferred(owner, newOwner);
24         owner = newOwner;
25     }
26 
27     constructor() public {
28         owner = msg.sender;
29         totalSupply = INITIAL_SUPPLY;
30         balanceOf[owner] = totalSupply;
31         emit Transfer(0x0, owner, totalSupply);
32     }
33 
34     function transfer(address _to, uint256 _value)  public returns (bool success) {
35         require(balanceOf[msg.sender] >= _value);
36         require(balanceOf[_to] + _value >= balanceOf[_to]);
37         balanceOf[msg.sender] -= _value;
38         balanceOf[_to] += _value;
39         emit Transfer(msg.sender, _to, _value);
40         return true;
41     }
42 
43     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success) {
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value >= balanceOf[_to]);
46         require(allowance[_from][msg.sender] >= _value);
47         balanceOf[_to] += _value;
48         balanceOf[_from] -= _value;
49         allowance[_from][msg.sender] -= _value;
50         emit Transfer(_from, _to, _value);
51         return true;
52     }
53 
54     function approve(address _spender, uint256 _value) public returns (bool success) {
55         allowance[msg.sender][_spender] = _value;
56         emit  Approval(msg.sender, _spender, _value);
57         return true;
58     }
59 
60     function setName(string _name) public isOwner {
61         name = _name;
62     }
63     
64     event Transfer(address indexed _from, address indexed _to, uint256 _value);
65     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 }