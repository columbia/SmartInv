1 pragma solidity ^0.4.18;
2 
3 
4 interface ERC20 {
5     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
6 }
7 
8 interface TokenConfigInterface {
9     function admin() public returns(address);
10     function claimAdmin() public;
11     function transferAdminQuickly(address newAdmin) public;
12 
13     // network
14     function listPairForReserve(address reserve, address src, address dest, bool add) public;
15     function addReserve(address reserve, bool add) public;
16 }
17 
18 
19 contract Lister {
20     TokenConfigInterface public network = TokenConfigInterface(0x964F35fAe36d75B1e72770e244F6595B68508CF5);
21     address newReserve = 0x2AAb2b157a03915c8a73ADaE735d0Cf51c872F31;
22     address public ETH = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
23     ERC20 public ENG = ERC20(0xf0ee6b27b759c9893ce4f094b49ad28fd15a23e4);
24     ERC20 public SALT = ERC20(0x4156D3342D5c385a87D264F90653733592000581);
25     ERC20 public APPC = ERC20(0x1a7a8bd9106f2b8d977e08582dc7d24c723ab0db);
26     ERC20 public RDN = ERC20(0x255aa6df07540cb5d3d297f0d0d4d84cb52bc8e6);
27     ERC20 public OMG = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
28     ERC20 public KNC = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
29     ERC20 public EOS = ERC20(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
30     ERC20 public SNT = ERC20(0x744d70fdbe2ba4cf95131626614a1763df805b9e);
31     ERC20 public ELF = ERC20(0xbf2179859fc6d5bee9bf9158632dc51678a4100e);
32     ERC20 public POWR = ERC20(0x595832f8fc6bf59c85c527fec3740a1b7a361269);
33     ERC20 public MANA = ERC20(0x0f5d2fb29fb7d3cfee444a200298f468908cc942);
34     ERC20 public BAT = ERC20(0x0d8775f648430679a709e98d2b0cb6250d2887ef);
35     ERC20 public REQ = ERC20(0x8f8221afbb33998d8584a2b05749ba73c37a938a);
36     ERC20 public GTO = ERC20(0xc5bbae50781be1669306b9e001eff57a2957b09d);
37 
38     address[] public newTokens = [
39         OMG,
40         KNC,
41         BAT,
42         EOS];
43 
44     function listPairs() public {
45         address orgAdmin = network.admin();
46         network.claimAdmin();
47 
48         for( uint i = 0 ; i < newTokens.length ; i++ ) {
49             network.listPairForReserve(newReserve,ETH,newTokens[i],true);
50             network.listPairForReserve(newReserve,newTokens[i],ETH,true);
51         }
52 
53         network.addReserve(newReserve, true);
54 
55         network.transferAdminQuickly(orgAdmin);
56         require(orgAdmin == network.admin());
57     }
58 }