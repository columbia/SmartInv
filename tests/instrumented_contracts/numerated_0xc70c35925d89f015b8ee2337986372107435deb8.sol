1 pragma solidity ^0.4.18;
2 
3 interface ERC20 {
4     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
5 }
6 
7 interface TokenConfigInterface {
8     function admin() public returns(address);
9     function claimAdmin() public;
10     function transferAdminQuickly(address newAdmin) public;
11 
12     // network
13     function listPairForReserve(address reserve, address src, address dest, bool add) public;
14 }
15 
16 
17 contract TokenAdder {
18     TokenConfigInterface public network = TokenConfigInterface(0xD2D21FdeF0D054D2864ce328cc56D1238d6b239e);
19     address public reserve = address(0x2C5a182d280EeB5824377B98CD74871f78d6b8BC);
20 
21     address public ETH = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee;
22     ERC20 public ADX = ERC20(0x4470BB87d77b963A013DB939BE332f927f2b992e);
23     ERC20 public AST = ERC20(0x27054b13b1b798b345b591a4d22e6562d47ea75a);
24     ERC20 public RCN = ERC20(0xf970b8e36e23f7fc3fd752eea86f8be8d83375a6);
25     ERC20 public RDN = ERC20(0x255aa6df07540cb5d3d297f0d0d4d84cb52bc8e6);
26     ERC20 public OMG = ERC20(0xd26114cd6EE289AccF82350c8d8487fedB8A0C07);
27     ERC20 public KNC = ERC20(0xdd974D5C2e2928deA5F71b9825b8b646686BD200);
28     ERC20 public EOS = ERC20(0x86Fa049857E0209aa7D9e616F7eb3b3B78ECfdb0);
29     ERC20 public SNT = ERC20(0x744d70fdbe2ba4cf95131626614a1763df805b9e);
30     ERC20 public ELF = ERC20(0xbf2179859fc6d5bee9bf9158632dc51678a4100e);
31     ERC20 public POWR = ERC20(0x595832f8fc6bf59c85c527fec3740a1b7a361269);
32     ERC20 public MANA = ERC20(0x0f5d2fb29fb7d3cfee444a200298f468908cc942);
33     ERC20 public BAT = ERC20(0x0d8775f648430679a709e98d2b0cb6250d2887ef);
34     ERC20 public REQ = ERC20(0x8f8221afbb33998d8584a2b05749ba73c37a938a);
35     ERC20 public GTO = ERC20(0xc5bbae50781be1669306b9e001eff57a2957b09d);
36     ERC20 public ENG = ERC20(0xf0ee6b27b759c9893ce4f094b49ad28fd15a23e4);
37     ERC20 public ZIL = ERC20(0x05f4a42e251f2d52b8ed15e9fedaacfcef1fad27);
38     ERC20 public LINK = ERC20(0x514910771af9ca656af840dff83e8264ecf986ca);
39 
40     address[] public newTokens = [
41         AST,
42         LINK,
43         ZIL];
44 
45     function TokenAdder(TokenConfigInterface _network, address _reserve, address _admin) public {
46         network = _network;
47         reserve = _reserve;
48     }
49 
50     function listPairs() public {
51         address orgAdmin = network.admin();
52         network.claimAdmin();
53 
54         for (uint i = 0; i < newTokens.length; i++) {
55             network.listPairForReserve(reserve, ETH, newTokens[i], true);
56             network.listPairForReserve(reserve, newTokens[i], ETH, true);
57         }
58 
59         network.transferAdminQuickly(orgAdmin);
60         require(orgAdmin == network.admin());
61     }
62 }