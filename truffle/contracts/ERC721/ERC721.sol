// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./IERC721.sol";
import "./IERC721Metadata.sol";

contract ERC721 is IERC721, IERC721Metadata {

    // IERC721Matadata 에서 name, symbol을 가져온다.
    string public override name;
    string public override symbol;
    
    // 지갑 주소 > 해당 지갑이 가진 토큰 수
    mapping(address => uint) private _balances;

    // tokenId > 해당 토큰의 소유자
    mapping(uint => address) private _owners;

    // 토큰이 위임된 address ?
    mapping(uint => address) private _tokenApprovals;

    // address 가 다른 address에게 위임을 맡겼는지 여부를 확인
    // a가 b에게 위임을 맡겼다면 a => mapping( b => true )
    mapping (address => mapping(address => bool)) private _operatorApprovals;

    //

    function balanceOf(address _owner) external override view returns(uint) {
        // 지갑 주소가 존재하는 주소여야 한다.
        require(_owner != address(0), "ERC721: no address exist" );
        // 매핑을 이용해 소유 토큰 수 확인
        return _balances[_owner];
    }

    function ownerOf(uint _tokenId) public override view returns(address) {
        address owner = _owners[_tokenId];
        require(owner != address(0), "ERC721 : no address exist");
        return owner;
    }

    function approve(address _to, uint _tokenId) external override {
        address owner = ownerOf(_tokenId);
        require(_to != owner, "ERC721 : cannot approve to yourself");

        _tokenApprovals[_tokenId] = _to;
        // 새로운 매핑 관계 형성
        emit Approval(owner, _to, _tokenId);
    }

    function getApproved(uint _tokenId) public override view returns(address) {
        require(ownerOf(_tokenId) != address(0), "ERC721 no master for nft to approve");
        return _tokenApprovals[_tokenId];
        // 해당 토큰이 누구에게 approve되었는지를 매핑을 이용해 보여줌
    }

    // _operator에게 모든 token의 위임을 주겠다
    function setApprovalForAll(address _operator, bool _approved) external override {
        require(msg.sender != _operator);
        _operatorApprovals[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator) public override view returns(bool) {
        return _operatorApprovals[_owner][_operator];
    }

    function _isApprovedOrOwner(address _spender, uint _tokenId) private view returns(bool) {
        address owner = ownerOf(_tokenId);
        require(owner != address(0));
        return (_spender == owner || isApprovedForAll(owner, _spender) || getApproved(_tokenId) == _spender);
        // owner 본인이거나, 전체 위임을 받은 사람이거나, 그 토큰을 위임 받은 사람이라면 true, 아니면 false
    }

    // 소유권 이전 함수
    function transferFrom(address _from, address _to, uint _tokenId) external override {
        // 소유권을 이전하려면 위임받은 사람이거나 주인이거나
        require(_isApprovedOrOwner(_from, _tokenId));
        require(_from != _to);

        _balances[_from] -= 1;
        _balances[_to] += 1;
        // 받는 사람과 주는 사람의 잔고 변화
        _owners[_tokenId] = _to;
        // 매핑에서 토큰의 소유자 값을 바꿔준다.

        emit Transfer(_from, _to, _tokenId);
        // 이벤트 방출
    }

    function tokenURI(uint256 _tokenId) external override virtual view returns (string memory) {}

    // 민팅에 관련된 함수
    function _mint (address _to, uint _tokenId) public {
        require(_to != address(0));
        address owner = ownerOf(_tokenId);
        require(owner == address(0));

        _balances[_to] += 1;
        _owners[_tokenId] = _to;

        emit Transfer(address(0), _to, _tokenId);
    }
}