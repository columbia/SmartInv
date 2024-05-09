1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   /**
28   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract KitFutureToken {
46     address public owner;
47     mapping(address => uint256) balances;
48     using SafeMath for uint256;
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     
51     string public constant name = "Karma Future Token";
52     string public constant symbol = "KIT-FUTURE";
53     uint8 public constant decimals = 18;
54     
55     function KitFutureToken() public {
56         owner = msg.sender;
57     }
58     
59     function balanceOf(address _owner) public view returns (uint256 balance) {
60         return balances[_owner];
61     }
62     
63     function issueTokens(address[] _recipients, uint256[] _amounts) public onlyOwner {
64         require(_recipients.length != 0 && _recipients.length == _amounts.length);
65         
66         for (uint i = 0; i < _recipients.length; i++) {
67             balances[_recipients[i]] = balances[_recipients[i]].add(_amounts[i]);
68             emit Transfer(address(0), _recipients[i], _amounts[i]);
69         }
70     }
71     
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 }