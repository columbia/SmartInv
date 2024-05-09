1 pragma solidity ^0.4.11;
2 // Cancelot dapp on-chain component.
3 // Forwards ENS .eth Registrar cancelBid(...) call if bid's Deed not yet cancelled.
4 // Author:  Noel Maersk (veox)
5 // License: GPLv3.
6 // Sources: https://gitlab.com/veox/cancelot (Not yet available during deployment time - stay tuned!..)
7 // Compile: solc 0.4.11+commit.68ef5810.Linux.g++ /w optimisations
8 
9 // Minimal implementation of the .eth Registrar interface.
10 contract RegistrarFakeInterface {
11     // Short-circuit address->bytes32->Deed mapping. Signature 0x5e431709.
12     mapping (address => mapping(bytes32 => address)) public sealedBids;
13     //mapping (address => mapping(bytes32 => Deed)) public sealedBids;
14     //function sealedBids(address bidder, bytes32 seal) constant returns(address);
15 
16     // Actual. Signature 0x2525f5c1.
17     function cancelBid(address bidder, bytes32 seal);
18 }
19 
20 // Sir Cancelot, the cancellation bot - banger of coconuts, protector of nothing.
21 // Game-theoretic looney. Sees the world burn, even if it doesn't. To be avoided.
22 contract Cancelot {
23     address public owner;
24     RegistrarFakeInterface registrar;
25 
26     modifier only_owner {
27         if (msg.sender == owner) _;
28     }
29 
30     function Cancelot(address _owner, address _registrar) {
31         owner = _owner;
32         registrar = RegistrarFakeInterface(_registrar);
33     }
34 
35     function cancel(address bidder, bytes32 seal) {
36         if (registrar.sealedBids(bidder, seal) != 0)
37             registrar.cancelBid.gas(msg.gas)(bidder, seal);
38     }
39 
40     function withdraw() {
41         owner.transfer(this.balance);
42     }
43 
44     function sweep(address bidder, bytes32 seal) {
45         cancel(bidder, seal);
46         withdraw();
47     }
48 
49     function () payable {}
50 
51     function terminate() only_owner {
52         selfdestruct(owner);
53     }
54 }