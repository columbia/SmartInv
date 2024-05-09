1 pragma solidity ^0.4.18;
2 /**
3  * Holds funds for a year.  Send to or deposit directly to this contract.
4  * Each new acccount is initialized with a 1 year hold period, and is only 
5  * retrievable from the designated address after the set hold time.
6 */
7 contract HodlerInvestmentClub {
8     uint public hodl_interval= 1 years;
9     uint public m_hodlers = 1;
10     
11     struct Hodler {
12         uint value;
13         uint time;
14     }
15     
16     mapping(address => Hodler) public hodlers;
17     
18     modifier onlyHodler {
19         require(hodlers[msg.sender].value > 0);
20         _;
21     }
22     
23     /* Constructor */
24     function HodlerInvestmentClub() payable public {
25         if (msg.value > 0)  {
26             hodlers[msg.sender].value = msg.value;
27             hodlers[msg.sender].time = now + hodl_interval;
28         }
29     }
30     
31     // join the club!
32     // make a deposit to another account if it exists 
33     // or initialize a deposit for a new account
34     function deposit(address _to) payable public {
35         require(msg.value > 0);
36         if (_to == 0) _to = msg.sender;
37         // if a new member, init a hodl time
38         if (hodlers[_to].time == 0) {
39             hodlers[_to].time = now + hodl_interval;
40             m_hodlers++;
41         } 
42         hodlers[_to].value += msg.value;
43     }
44     
45     // withdrawal can only occur after deposit time is exceeded
46     function withdraw() public onlyHodler {
47         require(hodlers[msg.sender].time <= now);
48         uint256 value = hodlers[msg.sender].value;
49         delete hodlers[msg.sender];
50         m_hodlers--;
51         require(msg.sender.send(value));
52     }
53     
54     // join the club!
55     // simple deposit and hold time set for msg.sender
56     function() payable public {
57         require(msg.value > 0);
58         hodlers[msg.sender].value += msg.value;
59         // init for first deposit
60         if (hodlers[msg.sender].time == 0) {
61             hodlers[msg.sender].time = now + hodl_interval;
62             m_hodlers++;
63         }
64     }
65 
66 }