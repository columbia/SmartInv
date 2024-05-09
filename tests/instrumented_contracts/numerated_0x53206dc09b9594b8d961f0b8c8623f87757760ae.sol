1 pragma solidity ^0.4.17;
2 
3 contract ExtendEvents {
4 
5     event LogQuery(bytes32 query, address userAddress);
6     event LogBalance(uint balance);
7     event LogNeededBalance(uint balance);
8     event CreatedUser(bytes32 username);
9     event UsernameDoesNotMatch(bytes32 username, bytes32 neededUsername);
10     event VerifiedUser(bytes32 username);
11     event UserTipped(address from, bytes32 indexed username, uint val);
12     event WithdrawSuccessful(bytes32 username);
13     event CheckAddressVerified(address userAddress);
14     event RefundSuccessful(address from, bytes32 username);
15     event GoldBought(uint price, address from, bytes32 to, string months, string priceUsd, string commentId, string nonce, string signature);
16 
17     mapping(address => bool) owners;
18 
19     modifier onlyOwners() {
20         require(owners[msg.sender]);
21         _;
22     }
23 
24     function ExtendEvents() {
25         owners[msg.sender] = true;
26     }
27 
28     function addOwner(address _address) onlyOwners {
29         owners[_address] = true;
30     }
31 
32     function removeOwner(address _address) onlyOwners {
33         owners[_address] = false;
34     }
35 
36     function goldBought(uint _price, 
37                         address _from, 
38                         bytes32 _to, 
39                         string _months,
40                         string _priceUsd, 
41                         string _commentId,
42                         string _nonce, 
43                         string _signature) onlyOwners {
44                             
45         GoldBought(_price, _from, _to, _months, _priceUsd, _commentId, _nonce, _signature);
46     }
47 
48     function createdUser(bytes32 _username) onlyOwners {
49         CreatedUser(_username);
50     }
51 
52     function refundSuccessful(address _from, bytes32 _username) onlyOwners {
53         RefundSuccessful(_from, _username);
54     }
55 
56     function usernameDoesNotMatch(bytes32 _username, bytes32 _neededUsername) onlyOwners {
57         UsernameDoesNotMatch(_username, _neededUsername);
58     }
59 
60     function verifiedUser(bytes32 _username) onlyOwners {
61         VerifiedUser(_username);
62     }
63 
64     function userTipped(address _from, bytes32 _username, uint _val) onlyOwners {
65         UserTipped(_from, _username, _val);
66     }
67 
68     function withdrawSuccessful(bytes32 _username) onlyOwners {
69         WithdrawSuccessful(_username);
70     }
71 
72     function logQuery(bytes32 _query, address _userAddress) onlyOwners {
73         LogQuery(_query, _userAddress);
74     }
75 
76     function logBalance(uint _balance) onlyOwners {
77         LogBalance(_balance);
78     }
79 
80     function logNeededBalance(uint _balance) onlyOwners {
81         LogNeededBalance(_balance);
82     }
83 
84 }