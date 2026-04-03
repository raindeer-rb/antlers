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

## Immutability

Antlers convert variables to immutable copies when passed as props to a child node.

## Parallelism

- Antlers processes items in for loops in parallel [UNRELEASED]
- Antlers processes `<{ MyNode }>` embeds in parallel too, starting with nodes at the end of the tree first [UNRELEASED]

## Config [UNRELEASED]

### Turning off parallelism

**Per method:**
```ruby
def render
  <{ parallelism: false }>
    # 1. Each item in for loop executed sequentially.
    <{ for: user in: @users }>
      <{ UserNode user=user }>
    <{ :for }>

    # 2. User node executed sequentially after for loop.
    <{ UserNode }>
  <{ :parallelism }>
end
```

**Per block:**
```ruby
<{ for: user in: @users parallelism: false }>
  <{ UserNode user=user }>
<{ :for }>
```

**Per directive:**
```ruby
<{ UserNode user=user for: user in: @users parallelism: false }>
```

## Philosophy

**#️⃣ Syntax.** Antlers syntax is not Ruby, but compiles to Ruby, and looks like Ruby in order to get syntax highlighting out of the box.
