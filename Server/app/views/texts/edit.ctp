<div class="texts form">
<?php echo $this->Form->create('Text');?>
	<fieldset>
		<legend><?php __('Edit Text'); ?></legend>
	<?php
		echo $this->Form->input('id');
		echo $this->Form->input('user_id');
		echo $this->Form->input('story_id');
		echo $this->Form->input('content');
	?>
	</fieldset>
<?php echo $this->Form->end(__('Submit', true));?>
</div>
<div class="actions">
	<h3><?php __('Actions'); ?></h3>
	<ul>

		<li><?php echo $this->Html->link(__('Delete', true), array('action' => 'delete', $this->Form->value('Text.id')), null, sprintf(__('Are you sure you want to delete # %s?', true), $this->Form->value('Text.id'))); ?></li>
		<li><?php echo $this->Html->link(__('List Texts', true), array('action' => 'index'));?></li>
		<li><?php echo $this->Html->link(__('List Users', true), array('controller' => 'users', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('New User', true), array('controller' => 'users', 'action' => 'add')); ?> </li>
		<li><?php echo $this->Html->link(__('List Stories', true), array('controller' => 'stories', 'action' => 'index')); ?> </li>
		<li><?php echo $this->Html->link(__('New Story', true), array('controller' => 'stories', 'action' => 'add')); ?> </li>
	</ul>
</div>