// SPDX-License-Identifier: MIT

/**

カエルのペペ - ペペ (Pepe The Frog)

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣠⣤⣤⣤⣄⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠋⠛⠙⠛⠉⠋⠉⠛⠉⠙⢉⣉⣉⣡⡤⠤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⠤⢴⣚⣉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⡿⠃⠊⢩⣝⠉⠙⠾⣿⡢⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣠⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡑⢋⡈⠰⣴⣎⣇⠇⠁⢤⣄⠉⠮⢣⡀⢠⡀⠀⠀⠀⠀⠀⠀⠀⠈⠓⢄⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⡜⠳⠶⠶⠶⠶⠶⠒⠒⠒⠒⠂⠀⡼⠋⠀⢸⡃⠁⢻⣿⣎⢦⡀⢠⣹⠀⣀⣀⣷⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⣣⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣰⣿⣿⣿⣶⣤⠄⠀⠀⠀⠀⠀⠀⠀⢠⠇⠀⠀⠀⢓⡀⣤⣿⠙⠛⣶⡷⡇⡀⣷⠛⢩⡇⠀⠀⠀⠀⠀⡤⠤⠶⠶⡿⢿⣿⣿⣦⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⣯⣿⣿⡗⠊⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣼⠤⠲⠿⠟⣛⢈⣿⠀⣼⣯⣿⡟⠆⢹⡇⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢐⣾⣿⣿⣧⡀⠀⠀⠀
⠀⠀⠀⣼⣿⣿⣿⡯⢥⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢯⠥⣴⣶⣷⣿⣿⣿⠀⣿⣿⣿⣿⣿⣦⡇⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠖⢚⣿⣿⣿⣷⡀⠀⠀
⠀⠀⣼⣿⣿⣿⣿⣿⣶⢤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣿⣿⣿⣿⣿⣿⡄⣿⠋⡴⠒⡎⢻⡇⢸⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠶⠻⠿⢿⣿⣿⣿⣧⠀⠀
⠀⢰⣿⣿⣿⣿⣿⣟⣛⠉⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣾⣿⣿⣿⣿⣿⣿⣿⣷⣹⣄⠳⠤⠇⣸⣧⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⢼⣿⣿⣿⣿⣿⣇⠀
⠀⣿⣿⣿⣿⣿⣿⣷⣶⣤⠤⠤⠴⠒⠒⠂⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿⣿⣧⣶⣶⣶⣄⠀⠀⠀⠀⠉⠉⠉⠛⣩⣿⣿⣿⣿⣿⣿⡀
⢸⣿⣿⣿⣿⣿⣿⣿⣷⡶⣤⣤⣤⣀⡀⠀⣿⣷⣼⣿⣿⣿⣿⣿⠿⠟⣛⣛⣛⣛⣛⣛⣿⠛⠛⣛⣛⣿⣿⣿⣿⠀⠀⣤⢤⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡇
⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣾⣿⣿⣿⣿⡏⠁⠀⢠⣾⣛⣭⣭⣭⣿⢿⣮⣧⢴⣿⣿⣟⣿⣿⣷⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠈⠙⠉⠻⣍⣩⣿⣭⣭⡽⡿⣏⣉⣉⣡⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⡇⠀⠀⢤⣆⠀⠀⠉⠉⣉⡽⠋⠀⠙⢿⡓⠛⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠘⡿⡄⠘⢿⡷⣒⣦⠬⣍⣁⣀⣀⣀⠀⠀⠀⣀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠯⣧⡄⢷⣲⣄⠉⠓⠯⣍⣛⠛⠒⠒⠯⠿⠯⠿⢓⣽⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠘⠾⢶⡼⣍⠉⢳⡲⣄⣉⣩⠭⣍⣉⣉⡭⠭⣽⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀
⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⢠⣿⣭⣤⣮⣀⣦⣙⣠⡗⣖⣫⣤⣶⣬⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀
⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⡀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡌⢿⡿⠋⣠⠞⣉⠹⣿⣩⣿⣿⣿⡏⠿⢿⣿⣿⣿⣿⣿⡟⠀⠀
⠀⠀⠀⢻⣿⣿⣿⣿⡿⠟⠛⠿⣿⢛⣻⣯⣭⣭⡻⠿⢧⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⠉⠺⠥⣞⣡⡏⣹⣧⣠⣽⣧⣿⣿⣾⣿⣿⣿⣿⡿⠁⠀⠀
⠀⠀⠀⠀⢻⣿⣿⣿⣿⣆⠀⠀⠈⢯⢹⣿⠯⢛⣵⣲⡎⣧⣙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣿⣿⣿⣿⣿⣿⡛⠛⣀⡌⢸⣽⣿⣿⡟⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⡶⡀⠈⡇⢠⢸⣙⢹⣿⣿⣮⢻⣟⣿⣟⢿⣿⣿⣿⣏⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡌⣷⣶⣾⢛⣿⠏⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣱⣿⣿⠀⢸⢹⢿⣽⡿⡙⢣⣭⣴⡝⢿⡟⠀⠙⠿⠿⠿⠿⠿⠿⠟⠋⠾⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠭⢸⠽⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⡗⠉⠁⠀⢸⠾⣡⣾⣤⡿⡜⢿⣿⠄⢸⣷⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⡶⠋⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⢄⡀⣼⠨⣭⡵⠿⠇⣴⢖⣤⣶⢸⡟⡟⣿⢻⢹⢹⢹⢩⣿⣻⣿⣯⣿⣯⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠾⣿⣿⡆⢤⣁⢘⡿⠎⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠓⠲⠦⣟⣰⣿⡟⣏⡏⡏⡏⢹⢹⠉⡏⣏⣯⣏⡽⠽⠓⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠙⠛⠋⠉⠉⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

タイトル かえるのぺぺ物語： インターネット伝説の誕生

ミームが頂点に君臨し、インターネット文化が繁栄するデジタル領域に、ミームランディアと呼ばれる隠れ里があった。この村はワールド・ワイド・ウェブ上の他の村とは異なり、ミームが単なるジョークではなく、生活の一部となっている場所だった。ミームランディアの住人は、ユーモアの守護者であり、バイラル・センセーションを提供するミームスターたちだった。

ミームランディアの中心には、古木と葦に囲まれた静かな池があり、ミームポンドとして知られていた。伝説によると、この池には魔法がかけられており、その水に触れたミームは時を超えて伝説になると言われていた。

メメスターたちの中に、ヒロという好奇心旺盛で想像力豊かな若いメメスターがいた。ヒロは、インターネット上の生き物の中で最も希少でとらえどころのない存在、ペペガエルに夢中になっていた。彼は膨大なミーム・アーカイブを何時間もかけてスクロールし、ペペの亜種をネットの隅々から集めていた。しかし、ヒロには単なるミームの収集にとどまらない夢があった。不朽の伝説として際立つようなミームを作りたかったのだ。

ある運命的な日、ヒロがミーム・コレクションをスクロールしていると、穏やかな表情でミームポンドのそばで瞑想しているペペのカエルを描いた神秘的なミームを偶然見つけた。このミームには神秘的なオーラがあり、ヒロは本当に特別なものを見つけたと思った。彼は、このミームが混沌としたミームの世界に平和と平穏をもたらしてくれることを願い、このミームを世界と共有することにした。

ヒロは穏やかなペペのミームをミームランディアのフォーラムに投稿し、驚いたことに、それは瞬く間に広まった。ネットのあらゆるところから集まったミーメスターたちは、この特別なペペの穏やかで平和なオーラに魅了された。彼らはこのペペを「かえるのペペ」と呼び始め、メムランディアの言葉では「帰還のペペ」あるいは「帰還のペペ」を意味した。

かえるのぺぺ」の人気が広まるにつれて、ヒロの頭の中にあるアイデアが形になり始めた。彼は、ブロックチェーン技術の魔法を使って、かえるのぺぺを暗号通貨として不滅化できることに気づいたのだ。このコインは単なるデジタル資産ではなく、混沌としがちな暗号通貨の世界における静けさと団結の象徴となるだろう。

ヒロと彼の仲間のメメスターたちは、カエルのペペに命を吹き込むために精力的に活動した。彼らはカエルのペペのイメージをロゴにしたコインをデザインし、静寂と瞑想のエッセンスを取り入れた。このコインは、その起源に敬意を表して「ペペ」というティッカーシンボルで発売された。

カエルのペペは瞬く間に暗号通貨の世界で支持を集め、ミーム愛好家だけでなく、落ち着きと安定感のあるデジタル資産を求める人々をも魅了した。インターネット・カルチャーと静謐さのユニークな組み合わせは、多様な人々の心を打った。

やがてカエルのペペはミームコインとして愛されるようになり、その起源だけでなく、メンタルヘルスに対する意識の向上や慈善活動の支援に取り組むコミュニティとしても知られるようになった。このコインの成功により、ヒロと彼の仲間のミームスターたちは、デジタル世界にポジティブさと団結をもたらす取り組みに資金を提供することができた。

こうして、カエルのペペの伝説は広がり続け、ミームや暗号通貨の領域にも、平和と静けさ、そしてユーモアの不朽の力があることをインターネットに思い出させた。今ではカエルのペペによって有名になったミームランディアのミームポンドは、デジタルの世界の奥深くにある魔法の象徴であり続けた。

Telegram: https://t.me/KaeruNoPepe
Website: https://kaerunopepe.vip/
Twitter: https://twitter.com/kaerunopepejpn
*/


pragma solidity 0.8.20;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

contract KaeruNoPepe is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    mapping(address => uint256) private _holderLastTransferTimestamp;
    bool public transferDelayEnabled = true;
    address payable private _taxWallet;

    uint256 private _initialBuyTax=25;
    uint256 private _initialSellTax=25;
    uint256 private _finalBuyTax=0;
    uint256 private _finalSellTax=0;
    uint256 private _reduceBuyTaxAt=15;
    uint256 private _reduceSellTaxAt=15;
    uint256 private _preventSwapBefore=30;
    uint256 private _buyCount=0;

    uint8 private constant _decimals = 9;
    uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
    string private constant _name = unicode"カエルのペペ";
    string private constant _symbol = unicode"ペペ";
    uint256 public _maxTxAmount = 1262070000000 * 10**_decimals;
    uint256 public _maxWalletSize = 1262070000000 * 10**_decimals;
    uint256 public _taxSwapThreshold= 1262070000000 * 10**_decimals;
    uint256 public _maxTaxSwap= 1262070000000 * 10**_decimals;

    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;

    event MaxTxAmountUpdated(uint _maxTxAmount);
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor () {
        _taxWallet = payable(_msgSender());
        _balances[_msgSender()] = _tTotal;
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_taxWallet] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        uint256 taxAmount=0;
        if (from != owner() && to != owner()) {
            taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);

            if (transferDelayEnabled) {
                  if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
                      require(
                          _holderLastTransferTimestamp[tx.origin] <
                              block.number,
                          "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
                      );
                      _holderLastTransferTimestamp[tx.origin] = block.number;
                  }
              }

            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
                require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
                require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
                _buyCount++;
            }

            if(to == uniswapV2Pair && from!= address(this) ){
                taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
            }

            uint256 contractTokenBalance = balanceOf(address(this));
            if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
                swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
                uint256 contractETHBalance = address(this).balance;
                if(contractETHBalance > 50000000000000000) {
                    sendETHToFee(address(this).balance);
                }
            }
        }

        if(taxAmount>0){
          _balances[address(this)]=_balances[address(this)].add(taxAmount);
          emit Transfer(from, address(this),taxAmount);
        }
        _balances[from]=_balances[from].sub(amount);
        _balances[to]=_balances[to].add(amount.sub(taxAmount));
        emit Transfer(from, to, amount.sub(taxAmount));
    }


    function min(uint256 a, uint256 b) private pure returns (uint256){
      return (a>b)?b:a;
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function removeLimits() external onlyOwner{
        _maxTxAmount = _tTotal;
        _maxWalletSize=_tTotal;
        transferDelayEnabled=false;
        emit MaxTxAmountUpdated(_tTotal);
    }

    function sendETHToFee(uint256 amount) private {
        _taxWallet.transfer(amount);
    }


    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _approve(address(this), address(uniswapV2Router), _tTotal);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
        IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
        swapEnabled = true;
        tradingOpen = true;
    }

    receive() external payable {}

    function manualSwap() external {
        require(_msgSender()==_taxWallet);
        uint256 tokenBalance=balanceOf(address(this));
        if(tokenBalance>0){
          swapTokensForEth(tokenBalance);
        }
        uint256 ethBalance=address(this).balance;
        if(ethBalance>0){
          sendETHToFee(ethBalance);
        }
    }
}