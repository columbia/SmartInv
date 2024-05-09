1 pragma solidity ^0.4.24;
2 
3 
4 interface ERC20 {
5     function totalSupply() external view returns (uint);
6     function balanceOf(address tokenOwner) external view returns (uint balance);
7     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
8     function transfer(address to, uint tokens) external returns (bool success);
9     function approve(address spender, uint tokens) external returns (bool success);
10     function transferFrom(address from, address to, uint tokens) external returns (bool success);
11 }
12 
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a, "Addition overflow");
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a, "Subtraction overflow");
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b, "Multiplication overflow");
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0, "The denominator is 0");
29         c = a / b;
30     }
31 }
32 
33 
34 contract BulkTransfer
35 {
36     using SafeMath for uint;
37     address owner;
38     
39     event MultiTransfer(
40         address indexed _from,
41         uint indexed _value,
42         address _to,
43         uint _amount
44     );
45 
46     event MultiERC20Transfer(
47         address indexed _from,
48         address _to,
49         uint _amount,
50         ERC20 _token
51     );
52     
53     constructor () public payable {
54         owner = msg.sender;
55     }
56     
57     function multiTransfer(address[] _addresses, uint[] _amounts) public payable returns(bool) {
58         uint toReturn = msg.value;
59         for (uint i = 0; i < _addresses.length; i++) {
60             _safeTransfer(_addresses[i], _amounts[i]);
61             toReturn = SafeMath.sub(toReturn, _amounts[i]);
62             emit MultiTransfer(msg.sender, msg.value, _addresses[i], _amounts[i]);
63         }
64         _safeTransfer(msg.sender, toReturn);
65         return true;
66     }
67 
68     function multiERC20Transfer(ERC20 _token, address[] _addresses, uint[] _amounts) public payable {
69         for (uint i = 0; i < _addresses.length; i++) {
70             _safeERC20Transfer(_token, _addresses[i], _amounts[i]);
71             emit MultiERC20Transfer(
72                 msg.sender,
73                 _addresses[i],
74                 _amounts[i],
75                 _token
76             );
77         }
78     }
79 
80     function _safeTransfer(address _to, uint _amount) internal {
81         require(_to != 0, "Receipt address can't be 0");
82         _to.transfer(_amount);
83     }
84 
85     function _safeERC20Transfer(ERC20 _token, address _to, uint _amount) internal {
86         require(_to != 0, "Receipt address can't be 0");
87         require(_token.transferFrom(msg.sender, _to, _amount), "Sending a token failed");
88     }
89 
90     function () public payable {
91         revert("Contract prohibits receiving funds");
92     }
93 
94     function forwardTransaction( address destination, uint amount, uint gasLimit, bytes data) internal {
95         require(msg.sender == owner, "Not an administrator");
96         require(
97             destination.call.gas(
98                 (gasLimit > 0) ? gasLimit : gasleft()
99             ).value(amount)(data), 
100             "operation failed"
101         );
102     }
103 }