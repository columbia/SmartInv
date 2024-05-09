1 pragma solidity ^0.4.17;
2 
3 /**
4  * Allows one to send EIP-20 tokens to multiple addresses cheaply.
5  * Copyright © 2017 by ABDK Consulting https://abdk.consulting/
6  * Author: Mikhail Vladimirov <mikhail.vladimirov[at]gmail.com>
7  */
8 contract BatchTokenSender {
9     /**
10      * If you like this contract, you may send some ether to this address and
11      * it will be used to develop more useful contracts available to everyone.
12      */
13     address public donationAddress;
14 
15     /**
16      * Create new Batch Token Sender with given donation address.
17      *
18      * @param _donationAddress donation address
19      */
20     function BatchTokenSender (address _donationAddress) public {
21         donationAddress = _donationAddress;
22     }
23 
24     /**
25      * Encode transfer amount and recepient address as a single uin256 value.
26      *
27      * @param _lotsNumber transfer amount as number of lots
28      * @param _to transfer recipient address
29      * @return encoded transfer
30      */
31     function encodeTransfer (uint96 _lotsNumber, address _to)
32     public pure returns (uint256 _encodedTransfer) {
33         return (_lotsNumber << 160) | uint160 (_to);
34     }
35 
36     /**
37      * Perform multiple token transfers from message sender's address.
38      *
39      * @param _token EIP-20 token smart contract that manages tokens to be sent
40      * @param _lotSize number of tokens in lot
41      * @param _transfers an array or encoded transfers to perform
42      */
43     function batchSend (
44         Token _token, uint160 _lotSize, uint256 [] _transfers) public {
45         uint256 count = _transfers.length;
46         for (uint256 i = 0; i < count; i++) {
47             uint256 transfer = _transfers [i];
48             uint256 value = (transfer >> 160) * _lotSize;
49             address to = address (
50                 transfer & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);
51             if (!_token.transferFrom (msg.sender, to, value)) revert ();
52         }
53     }
54 }
55 
56 /**
57  * EIP-20 standard token interface, as defined
58  * <a href="https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md">here</a>.
59  */
60 contract Token {
61     /**
62      * Get total number of tokens in circulation.
63      *
64      * @return total number of tokens in circulation
65      */
66     function totalSupply ()
67     public constant returns (uint256 supply);
68 
69     /**
70      * Get number of tokens currently belonging to given owner.
71      *
72      * @param _owner address to get number of tokens currently belonging to the
73      *        owner of
74      * @return number of tokens currently belonging to the owner of given
75      *         address
76      */
77     function balanceOf (address _owner)
78     public constant returns (uint256 balance);
79 
80     /**
81      * Transfer given number of tokens from message sender to given recipient.
82      *
83      * @param _to address to transfer tokens to the owner of
84      * @param _value number of tokens to transfer to the owner of given address
85      * @return true if tokens were transferred successfully, false otherwise
86      */
87     function transfer (address _to, uint256 _value)
88     public returns (bool success);
89 
90     /**
91      * Transfer given number of tokens from given owner to given recipient.
92      *
93      * @param _from address to transfer tokens from the owner of
94      * @param _to address to transfer tokens to the owner of
95      * @param _value number of tokens to transfer from given owner to given
96      *        recipient
97      * @return true if tokens were transferred successfully, false otherwise
98      */
99     function transferFrom (address _from, address _to, uint256 _value)
100     public returns (bool success);
101 
102     /**
103      * Allow given spender to transfer given number of tokens from message
104      * sender.
105      *
106      * @param _spender address to allow the owner of to transfer tokens from
107      *        message sender
108      * @param _value number of tokens to allow to transfer
109      * @return true if token transfer was successfully approved, false otherwise
110      */
111     function approve (address _spender, uint256 _value)
112     public returns (bool success);
113 
114     /**
115      * Tell how many tokens given spender is currently allowed to transfer from
116      * given owner.
117      *
118      * @param _owner address to get number of tokens allowed to be transferred
119      *        from the owner of
120      * @param _spender address to get number of tokens allowed to be transferred
121      *        by the owner of
122      * @return number of tokens given spender is currently allowed to transfer
123      *         from given owner
124      */
125     function allowance (address _owner, address _spender)
126     public constant returns (uint256 remaining);
127 
128     /**
129      * Logged when tokens were transferred from one owner to another.
130      *
131      * @param _from address of the owner, tokens were transferred from
132      * @param _to address of the owner, tokens were transferred to
133      * @param _value number of tokens transferred
134      */
135     event Transfer (address indexed _from, address indexed _to, uint256 _value);
136 
137     /**
138      * Logged when owner approved his tokens to be transferred by some spender.
139      * @param _owner owner who approved his tokens to be transferred
140      * @param _spender spender who were allowed to transfer the tokens belonging
141      *        to the owner
142      * @param _value number of tokens belonging to the owner, approved to be
143      *        transferred by the spender
144      */
145     event Approval (
146         address indexed _owner, address indexed _spender, uint256 _value);
147 }