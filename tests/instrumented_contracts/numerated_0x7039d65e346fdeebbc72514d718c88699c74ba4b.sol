1 pragma solidity ^0.5.16;
2     //This is the official Happy Face Place.
3     //You can send ChainFaces to this contract, but nobody will ever be able to retrieve them.
4     //No, not even Zoma
5 
6 contract ChainFaces{
7     //Come to the Happy Face Place my beautiful children <3
8     function createFace(uint256 seed) public payable {}
9 }
10 
11 contract IERC721Receiver {
12     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4);
13 }
14 
15 contract HappyFacePlace is IERC721Receiver{
16     
17     address natealex;
18     
19     uint previousBlockNumber;
20     
21     uint totalAscended = 0;
22     
23     ChainFaces chainFaces;
24     
25     modifier ZomaNotAllowed {
26         require(msg.sender == natealex);
27         _;
28     }
29     
30     constructor () public{
31         natealex = msg.sender;
32         chainFaces = ChainFaces(0x91047Abf3cAb8da5A9515c8750Ab33B4f1560a7A);
33     }
34     
35     function MintAFaceForTheHappyPlace() public ZomaNotAllowed{
36         //A Block a Face keeps the Faces Happy
37         require(previousBlockNumber < block.number,"Each block deserves a Face in the Happy Face Place.");
38         require(address(this).balance > 20 finney, "Any amount of Eth is worth eternal pleasure.");
39         previousBlockNumber = block.number-10; //Lets not get too crazy in here loves
40         
41         //Come home to papa
42         chainFaces.createFace.value(14 finney)(4206969);
43         
44         totalAscended++;
45     }
46     
47     function UseDifferentAddress(address addr) public ZomaNotAllowed{
48         natealex = addr;
49     }
50     
51     function AddEth() public payable{
52         //Zoma you can use this one if you like >.>
53         require(msg.value > 0 wei);
54     }
55     
56     function SubWei(uint weiAmt) public ZomaNotAllowed{
57         msg.sender.transfer(weiAmt);
58     }
59     function EmptyEth() public ZomaNotAllowed{
60         msg.sender.transfer(address(this).balance);
61     }
62     function GetTotalAscended() external view returns(uint){
63         return totalAscended;
64     }
65     //IERC721Receiver implementation
66     function onERC721Received(address, address, uint256, bytes memory) public returns (bytes4) {
67         return this.onERC721Received.selector;
68     }
69 }