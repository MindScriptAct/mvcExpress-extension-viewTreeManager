mvcExpress-extension-viewTreeManager
====================================


 viewTreeManager is extension for mvcExpress as3 framework, designed to work with view stack.
 
 Responcibilities:
 
  - manage view creation/destruction. **[DONE]**
  - define fluid interfaces. *[work in progress]*
  - define view transitions. *[planned]*


Current work-flow:

**1:** first you must define root view object. you do it from your ModuleCore class: **Temporal implementation, most likely will be refactored to module extension.**

> var rootDefinition:ViewDefinition =  ViewTreeManager.initRootDefinition(module, mainObject, MainMediator); 

**2:** then you add child view definitions, (views will be sorted then added in order they are defined): 


> rootDefinition.pushViews(...);

**3:** view definitions supported:

 - StaticViewDefinition - not mediated view object.
 - ViewDefinition - mediated view object.
 - ViewComboDefinition - collection of view definitions, one and only one will be shown. (last triggered to be added)
 - ViewStackDefinition - collection of view definitions, views are not sorted. (added on top of the stack then triggered)
 - ViewGroupDefinition - collection of view definitions, helps to define messages that will act on all group views.
 
**4:** view definitions functions supported:

 - addOn("addMessage"), creates, mediates and adds view to parent view then this message is sent. (can have more then one message)
 - removeOn("removeMessage"), unmediates and removes view from parent view then this message is sent. (can have more then one message)
 - toggleOn("removeMessage"), this messages will add view if it's not added, and remove if it is. (can have more then one message)
 - autoAdd(), automatically adds this view then parent view as added.
 - positionTo(200, 200), will set x and y of object after creation.
 - sizeTo(100, 200), will set width and height of object after creation.
 - sizeAs(100, 200), will NOT set width and height of object, instead it will use these for fluid interface calculations.
 
 - injectIntoParentAs("variableName"), will inject view to parent view as this variable. (variable must be public.)
 - executeParentFunctionOnAdd("functionName", [param1, param2]), will execute parent view function with given name on add, with optional parameters.
 - executeParentFunctionOnRemove("functionName", [param1, param2]), will execute parent view function with given name on remove, with optional parameters.
 
