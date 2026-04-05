<a href="https://rubygems.org/gems/antlers" title="Install gem"><img src="https://badge.fury.io/rb/antlers.svg" alt="Gem version" height="18"></a>

# Antlers

`<{ Antlers }>` is a templating language designed to be embedded within HTML, where that HTML itself is embedded within a Ruby file.
This gives Antlers access to the class it's embedded in at runtime where it can perform additional logic.

Antlers is used by [LowNode](https://github.com/low-rb/low_node) to render child nodes in a compositional way.

## Syntax

### Variables

Access an instance variable with:
```ruby
def render
  <html>{@user}</html>
end
```

ℹ️ Variables (`{}`) are also useful for embedding text in RBX without Ruby syntax highlighting issues:
```ruby
def render
  <html>{"I'm just a string"}</html>
end
```

### Components

Render a class named `UserNode` with:
```ruby
def render
  <html><{ UserNode }></html>
end
```

**Props:**
```ruby
def render
  <html><{ UserNode user=@user }></html>
end
```

**Slots:**
```ruby
def render
  <html>
    <{ LayoutNode: username=@user.username }>
      <{ UserNode user=@user }>
    <{ :LayoutNode }>
  </html>
end
```

The `LayoutNode` would look like:
```ruby
class LayoutNode
  def render(event:, **props)
    <header>Site Name</header>
    <{ :slot }>
    <footer>More Info</footer>
  end
end
```

### Conditionals [UNRELEASED]

```ruby
# Block.
<{ if: @user.happy? }>
  <{ UserNode user=@user }>
<{ :if }>

# Directive.
<{ UserNode user=@user if: @user.happy? }>
```

### Loops [UNRELEASED]

```ruby
# Block.
<{ for: user in: @users }>
  <{ UserNode user=user }>
<{ :for }>

# Directive.
<{ UserNode user=user for: user in: @users }>

# Directive with simplified prop.
<{ UserNode user for: user in: @users }>
```

## Config [UNRELEASED]

### Enabling parallelism

Add parallelism where it makes sense and you can measure the performance outcome and keep data integrity.

**Per sibling:**
```ruby
def render
  <{ parallelize: }>
    # For Loop executed at the same time as UserNode.
    <{ for: user in: @users }>
      <{ UserNode user=user }>
    <{ :for }>

    # PostsNode executed at the same time as For Loop.
    <{ PostsNode }>
  <{ :parallelize }>
end
```

ℹ️ The For loop in the example above still renders `PostsNode`s sequentially unless you use `map:` with a `:parallelize` directive.

**Per block:**
```ruby
# Each UserNode rendered at the same time.
<{ map: user in: @users :parallelize }>
  <{ UserNode user=user }>
<{ :map }>
```

**Per directive:**
```ruby
<{ UserNode user=user for: user in: @users :parallelize }>
```

## Philosophy

- **#️⃣ Syntax.** Antlers syntax looks like Ruby in order to get syntax highlighting out of the box.
- **⏳ Future.** Antlers should parallelize immutable data structures automatically [GOAL], see [LowNode](https://github.com/low-rb/low_node).
