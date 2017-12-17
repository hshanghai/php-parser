package expr

import (
	"fmt"
	"io"

	"github.com/z7zmey/php-parser/node"
)

type ShortList struct {
	node.SimpleNode
	items []node.Node
}

func NewShortList(items []node.Node) node.Node {
	return ShortList{
		node.SimpleNode{Name: "ShortList", Attributes: make(map[string]string)},
		items,
	}
}

func (n ShortList) Print(out io.Writer, indent string) {
	fmt.Fprintf(out, "\n%v%v [- -]", indent, n.Name)

	if n.items != nil {
		fmt.Fprintf(out, "\n%vitems:", indent+"  ")
		for _, nn := range n.items {
			nn.Print(out, indent+"    ")
		}
	}
}
