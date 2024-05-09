1 //
2 // Simple MultiSig Wallet Contract by Christian Lundkvist
3 // https://github.com/christianlundkvist/simple-multisig
4 //
5 //
6 //  Copyright (c) 2017 Christian Lundkvist
7 //
8 //  Permission is hereby granted, free of charge, to any person obtaining a copy
9 //  of this software and associated documentation files (the "Software"), to deal
10 //  in the Software without restriction, including without limitation the rights
11 //  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 //  copies of the Software, and to permit persons to whom the Software is
13 //  furnished to do so, subject to the following conditions:
14 //
15 //  The above copyright notice and this permission notice shall be included in all
16 //  copies or substantial portions of the Software.
17 //
18 //  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
19 //  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
20 //  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
21 //  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
22 //  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
23 //  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
24 //  SOFTWARE.
25 //
26 pragma solidity 0.4.18;
27 contract SimpleMultiSig {
28 
29   uint public nonce;                // (only) mutable state
30   uint public threshold;            // immutable state
31   mapping (address => bool) isOwner; // immutable state
32   address[] public ownersArr;        // immutable state
33 
34   function SimpleMultiSig(uint threshold_, address[] owners_) public {
35     require(owners_.length <= 10 && threshold_ <= owners_.length && threshold_ != 0);
36 
37     address lastAdd = address(0);
38     for (uint i=0; i<owners_.length; i++) {
39       require(owners_[i] > lastAdd);
40       isOwner[owners_[i]] = true;
41       lastAdd = owners_[i];
42     }
43     ownersArr = owners_;
44     threshold = threshold_;
45   }
46 
47   // Note that address recovered from signatures must be strictly increasing
48   function execute(uint8[] sigV, bytes32[] sigR, bytes32[] sigS, address destination, uint value, bytes data) public {
49     require(sigR.length == threshold);
50     require(sigR.length == sigS.length && sigR.length == sigV.length);
51 
52     // Follows ERC191 signature scheme: https://github.com/ethereum/EIPs/issues/191
53     bytes32 txHash = keccak256(byte(0x19), byte(0), address(this), destination, value, data, nonce);
54 
55     address lastAdd = address(0); // cannot have address(0) as an owner
56     for (uint i = 0; i < threshold; i++) {
57       address recovered = ecrecover(txHash, sigV[i], sigR[i], sigS[i]);
58       require(recovered > lastAdd && isOwner[recovered]);
59       lastAdd = recovered;
60     }
61 
62     // If we make it here all signatures are accounted for
63     nonce = nonce + 1;
64     require(destination.call.value(value)(data));
65   }
66 
67   function () public payable {}
68 }