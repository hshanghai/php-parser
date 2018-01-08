package expr

import (
	"github.com/z7zmey/php-parser/comment"
	"github.com/z7zmey/php-parser/node"
)

type StaticCall struct {
	position  *node.Position
	comments  *[]comment.Comment
	Class     node.Node
	Call      node.Node
	Arguments []node.Node
}

func NewStaticCall(Class node.Node, Call node.Node, Arguments []node.Node) *StaticCall {
	return &StaticCall{
		nil,
		nil,
		Class,
		Call,
		Arguments,
	}
}

func (n StaticCall) Attributes() map[string]interface{} {
	return nil
}

func (n StaticCall) Position() *node.Position {
	return n.position
}

func (n StaticCall) SetPosition(p *node.Position) node.Node {
	n.position = p
	return n
}

func (n StaticCall) Comments() *[]comment.Comment {
	return n.comments
}

func (n StaticCall) SetComments(c *[]comment.Comment) node.Node {
	n.comments = c
	return n
}

func (n StaticCall) Walk(v node.Visitor) {
	if v.EnterNode(n) == false {
		return
	}

	if n.Class != nil {
		vv := v.GetChildrenVisitor("Class")
		n.Class.Walk(vv)
	}

	if n.Call != nil {
		vv := v.GetChildrenVisitor("Call")
		n.Call.Walk(vv)
	}

	if n.Arguments != nil {
		vv := v.GetChildrenVisitor("Arguments")
		for _, nn := range n.Arguments {
			nn.Walk(vv)
		}
	}

	v.LeaveNode(n)
}
