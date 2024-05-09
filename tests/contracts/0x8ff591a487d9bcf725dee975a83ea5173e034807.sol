pragma solidity ^0.5.0;

interface ISplinterlands {
    function mintCard(string calldata splinterId, address owner) external;
    function unlockCard(uint256 _ethId, address _newHolder) external;
    function tokenIdForCardId(string calldata _splinterId) external view returns (uint256);
    function burnCard(uint256 _ethId) external;
}

contract CardMinter {

    address splinterlandsAddr;
    address signer1;
    address signer2;
    address signer3;

    struct SubstitutionProposal {
        address proposer;
        address affirmer;
        address retiree;
        address replacement;
    }

    mapping(address => SubstitutionProposal) proposals;

    constructor(address _splinterlandsAddr, address _signer1, address _signer2, address _signer3) public {
        splinterlandsAddr = _splinterlandsAddr;
        signer1 = _signer1;
        signer2 = _signer2;
        signer3 = _signer3;
    }

    function mintCard(string memory _splinterId, address _cardHolder) public onlySigner {
        ISplinterlands splinterlands = ISplinterlands(splinterlandsAddr);

        splinterlands.mintCard(_splinterId, _cardHolder);
    }

    function unlockCard(string memory _splinterId, address _cardHolder) public onlySigner {
        ISplinterlands splinterlands = ISplinterlands(splinterlandsAddr);

        splinterlands.unlockCard(
                    splinterlands.tokenIdForCardId(_splinterId),
                    _cardHolder
                );
    }

    function burnCard(string memory _splinterId) public onlySigner {
        ISplinterlands splinterlands = ISplinterlands(splinterlandsAddr);
        splinterlands.burnCard(splinterlands.tokenIdForCardId(_splinterId));
    }

    function proposeSubstitution(
                address _affirmer,
                address _retiree,
                address _replacement
            )
                public
                onlySigner
                isSigner(_affirmer)
                isSigner(_retiree)
                notSigner(_replacement)
    {
        address _proposer = msg.sender;

        require(_affirmer != _proposer, "CardMinter: Affirmer Is Proposer");
        require(_affirmer != _retiree, "CardMinter: Affirmer Is Retiree");
        require(_proposer != _retiree, "CardMinter: Retiree Is Proposer");

        proposals[_proposer] = SubstitutionProposal(_proposer, _affirmer, _retiree, _replacement);
    }

    function withdrawProposal() public onlySigner {
        delete proposals[msg.sender];
    }

    function withdrawStaleProposal(address _oldProposer) public onlySigner notSigner(_oldProposer) {
        delete proposals[_oldProposer];
    }

    function acceptProposal(address _proposer) public onlySigner isSigner(_proposer) {
        SubstitutionProposal storage proposal = proposals[_proposer];

        require(proposal.affirmer == msg.sender, "CardMinter: Not Affirmer");

        if (signer1 == proposal.retiree) {
            signer1 = proposal.replacement;
        } else if (signer2 == proposal.retiree) {
            signer2 = proposal.replacement;
        } else if (signer3 == proposal.retiree) {
            signer3 = proposal.replacement;
        }

        delete proposals[_proposer];
    }

    modifier onlySigner() {
        require(msg.sender == signer1 ||
                msg.sender == signer2 ||
                msg.sender == signer3,
                "CardMinter: Not Signer");
        _;
    }

    modifier isSigner(address _addr) {
        require(_addr == signer1 ||
                _addr == signer2 ||
                _addr == signer3,
                "CardMinter: Addr Not Signer");
        _;
    }

    modifier notSigner(address _addr) {
        require(_addr != signer1 &&
                _addr != signer2 &&
                _addr != signer3,
                "CardMinter: Addr Is Signer");
        _;
    }
}