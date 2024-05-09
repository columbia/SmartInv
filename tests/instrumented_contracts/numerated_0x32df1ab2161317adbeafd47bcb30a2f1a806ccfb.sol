1 pragma solidity ^0.4.2;
2 
3 contract TokenBaseAsset {
4     
5     address mOwner = msg.sender;
6     
7     string public mCompany;
8 	
9     mapping(string => string) mTokens;
10     
11     modifier isOwner() { require(msg.sender == mOwner); _; }
12 
13     function TokenBaseAsset(string pCompany) public {
14         mCompany = pCompany;
15     }
16     
17 	function addToken(string pDocumentHash, string pDocumentToken) public {
18 	    require(msg.sender == mOwner);
19         mTokens[pDocumentHash] = pDocumentToken;
20 	}
21     
22 	function removeToken(string pDocumentHash) public {
23 	    require(msg.sender == mOwner);
24         mTokens[pDocumentHash] = "";
25 	}
26 	
27 	function getToken(string pDocumentHash) view public returns(string) {
28 	    return mTokens[pDocumentHash];
29 	}
30 
31 }