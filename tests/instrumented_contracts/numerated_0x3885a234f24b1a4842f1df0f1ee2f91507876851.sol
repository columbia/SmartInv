1 pragma solidity ^0.4.24;
2 
3 contract ERC20 {
4     function transferFrom(address _from, address _to, uint _value) returns (bool success);
5 }
6 
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 contract MultiSender {
54     using SafeMath for uint256;
55 
56     function multiSend(address tokenAddress, address[] addresses, uint256[] amounts) public payable {
57         require(addresses.length <= 100);
58         require(addresses.length == amounts.length);
59         if (tokenAddress == 0x000000000000000000000000000000000000bEEF) {
60             multisendEther(addresses, amounts);
61         } else {
62             ERC20 token = ERC20(tokenAddress);
63             //Token address
64             for (uint8 i = 0; i < addresses.length; i++) {
65                 address _address = addresses[i];
66                 uint256 _amount = amounts[i];
67                 token.transferFrom(msg.sender, _address, _amount);
68             }
69         }
70     }
71 
72     function multisendEther(address[] addresses, uint256[] amounts) public payable {
73         uint256 total = msg.value;
74         uint256 i = 0;
75         for (i; i < addresses.length; i++) {
76             require(total >= amounts[i]);
77             total = total.sub(amounts[i]);
78             addresses[i].transfer(amounts[i]);
79         }
80     }
81 }